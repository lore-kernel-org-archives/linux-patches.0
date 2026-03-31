Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E737317166;
	Tue, 31 Mar 2026 16:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975585; cv=none; b=JQfb9bZokA12dYwuhJ47H9CjodMga+803b6eqRXvpcKELB4un1oxhOw7eRV15/jfjfNairEtQa+vK1OerM0zZ0UICCngXyLb05+qC7pOpYwmWdQkmssYDFUqfzSC+TcucIcSI3jQH7pUQSoKOJ49WcJREte2JURQCtjbF9+ACAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975585; c=relaxed/simple;
	bh=o8rbCx1d+L+tR4rLB1a6mPKDVjvDB1qNIadzJtxlMgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BxONvgtXDiknYbR5rLHF1YQwe9Xr7r/M5xcDMsTYC+jtG4HnOP+eI4QWlmgffU3P3oi0H1FNXry/nKHdOmlYqKMhwzCsCizNL6ntz5k5+0GHcCMkhqLYEPD4/KZmmMFy7ThWrHN3OFlr+uqhNqNCs9DuiBf7zfPGojakBXNR7qM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hOvNFE9R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hOvNFE9R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0540EC19423;
	Tue, 31 Mar 2026 16:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975585;
	bh=o8rbCx1d+L+tR4rLB1a6mPKDVjvDB1qNIadzJtxlMgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hOvNFE9RA5Xrf0tAajuzFK9R6sAWk7WZ0iy0xpAQoqsqri2ORScRml8906/dX9B5Y
	 fFrCBjKsHL6KrnAZ9ByXZyakPIyx26t7WiqCBqACXSgnbARCx9fU1tPAKtrGQ5K0UF
	 2D4PvyApsWCd1tcfniET5SBRHQsGR3si6r0Xyxb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Jiang <dave.jiang@intel.com>,
	Li Ming <ming.li@zohomail.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 001/244] cxl/port: Fix use after free of parent_port in cxl_detach_ep()
Date: Tue, 31 Mar 2026 18:19:11 +0200
Message-ID: <20260331161741.710814226@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alison Schofield <alison.schofield@intel.com>

[ Upstream commit 19d2f0b97a131198efc2c4ca3eb7f980bba8c2b4 ]

cxl_detach_ep() is called during bottom-up removal when all CXL memory
devices beneath a switch port have been removed. For each port in the
hierarchy it locks both the port and its parent, removes the endpoint,
and if the port is now empty, marks it dead and unregisters the port
by calling delete_switch_port(). There are two places during this work
where the parent_port may be used after freeing:

First, a concurrent detach may have already processed a port by the
time a second worker finds it via bus_find_device(). Without pinning
parent_port, it may already be freed when we discover port->dead and
attempt to unlock the parent_port. In a production kernel that's a
silent memory corruption, with lock debug, it looks like this:

[]DEBUG_LOCKS_WARN_ON(__owner_task(owner) != get_current())
[]WARNING: kernel/locking/mutex.c:949 at __mutex_unlock_slowpath+0x1ee/0x310
[]Call Trace:
[]mutex_unlock+0xd/0x20
[]cxl_detach_ep+0x180/0x400 [cxl_core]
[]devm_action_release+0x10/0x20
[]devres_release_all+0xa8/0xe0
[]device_unbind_cleanup+0xd/0xa0
[]really_probe+0x1a6/0x3e0

Second, delete_switch_port() releases three devm actions registered
against parent_port. The last of those is unregister_port() and it
calls device_unregister() on the child port, which can cascade. If
parent_port is now also empty the device core may unregister and free
it too. So by the time delete_switch_port() returns, parent_port may
be free, and the subsequent device_unlock(&parent_port->dev) operates
on freed memory. The kernel log looks same as above, with a different
offset in cxl_detach_ep().

Both of these issues stem from the absence of a lifetime guarantee
between a child port and its parent port.

Establish a lifetime rule for ports: child ports hold a reference to
their parent device until release. Take the reference when the port
is allocated and drop it when released. This ensures the parent is
valid for the full lifetime of the child and eliminates the use after
free window in cxl_detach_ep().

This is easily reproduced with a reload of cxl_acpi in QEMU with CXL
devices present.

Fixes: 2345df54249c ("cxl/memdev: Fix endpoint port removal")
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Li Ming <ming.li@zohomail.com>
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Link: https://patch.msgid.link/20260226184439.1732841-1-alison.schofield@intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/port.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index af92c67bc9542..6eb2e69361412 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -539,10 +539,13 @@ static void cxl_port_release(struct device *dev)
 	xa_destroy(&port->dports);
 	xa_destroy(&port->regions);
 	ida_free(&cxl_port_ida, port->id);
-	if (is_cxl_root(port))
+
+	if (is_cxl_root(port)) {
 		kfree(to_cxl_root(port));
-	else
+	} else {
+		put_device(dev->parent);
 		kfree(port);
+	}
 }
 
 static ssize_t decoders_committed_show(struct device *dev,
@@ -710,6 +713,7 @@ static struct cxl_port *cxl_port_alloc(struct device *uport_dev,
 		struct cxl_port *iter;
 
 		dev->parent = &parent_port->dev;
+		get_device(dev->parent);
 		port->depth = parent_port->depth + 1;
 		port->parent_dport = parent_dport;
 
-- 
2.51.0



