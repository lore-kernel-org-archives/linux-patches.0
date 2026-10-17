Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC993D45DE;
	Sat, 17 Oct 2026 17:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258414; cv=none; b=COFwTVxWEokKqbL+hyYk4GcxhgplgGwPNQHyNAw1wVPTk20qZZqZ+ezhL/MViyf8uCVIkp0sqcomES4jSOPLbgRIwxwSTFENNEVtigeUt0jPb1WUlddz6psm32ltn2PQBvHCiUauZAs/1U0xhfs9F9lxuQDEvxBVwzB3+pCdpbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258414; c=relaxed/simple;
	bh=l/2fkeKCGlLP+MzbniE0qsKfJAVw1kfkcMIpvlhvJUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WrvwR2gD1hlF2Sxdybh8ppmG48xPyzOKVDFO8b405kBWaVFcn/lhwqV8D10UkZ5MIH4lBwS8v7A+mYOM4g0jtGy02PeG6d93D/lQfpUR1l70889qe/3G47zdcYqXdENmMYLrhbwIqQfwggQuTP5X/2Lhr31qZDtAbFWTkGUrnFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m0MuL53c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m0MuL53c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 522771F000C4;
	Sat, 17 Oct 2026 17:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258412;
	bh=ydTbcOIfeqxs0RcbjTshRrrmJChCdmo/7vfoupUTb1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m0MuL53cQ7+Hs0wOeHeXOSMVhY9GB0laRgIgsjul5qTAqt1znOQyETPrc2zpGzl3A
	 7GiXwY0It7t22meti8gkSpuhYc8Btoe7UzpIa1DhbwhXtdj8sM2drMUTDQ5FYxpa9Q
	 Bz3k6FeNOq64gKXB2bL2DW0T4XR0mKztFq3UeiZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Jiang <dave.jiang@intel.com>,
	Li Ming <ming.li@zohomail.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0875/1674] cxl/port: Fix use after free of parent_port in cxl_detach_ep()
Date: Sat, 17 Oct 2026 17:52:27 +0200
Message-ID: <20261017160453.574031513@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/cxl/core/port.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 7f28d1021fa99..f23b5d6cde070 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -527,6 +527,9 @@ static void cxl_port_release(struct device *dev)
 	xa_destroy(&port->dports);
 	xa_destroy(&port->regions);
 	ida_free(&cxl_port_ida, port->id);
+
+	if (!is_cxl_root(port))
+		put_device(dev->parent);
 	kfree(port);
 }
 
@@ -657,6 +660,7 @@ static struct cxl_port *cxl_port_alloc(struct device *uport_dev,
 		struct cxl_port *iter;
 
 		dev->parent = &parent_port->dev;
+		get_device(dev->parent);
 		port->depth = parent_port->depth + 1;
 		port->parent_dport = parent_dport;
 
@@ -1380,8 +1384,8 @@ static void cxl_detach_ep(void *data)
 				dev_name(&port->dev));
 			delete_switch_port(port);
 		}
-		put_device(&port->dev);
 		device_unlock(&parent_port->dev);
+		put_device(&port->dev);
 	}
 }
 
-- 
2.53.0



