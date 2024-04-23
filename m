Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC3D14388F;
	Tue, 23 Apr 2024 21:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908513; cv=none; b=uRVSII5uXpRbSS5noTHnB/tZamIYXqpM5PYk6jHsfUz3yFZ6nD6bE+iwOBZDi8UW2kP1P63crkMZMWsnUtOA5/V7/FuQkZeGnbXyqFnH6/eilHubTe1uX0YzcrZtEDHscMKXrY5QPzWhjy2T2bTwI4V2yKWdcUnBa+DItvdP6PY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908513; c=relaxed/simple;
	bh=7nC1IWxTKT+pq4h51pai/fTYeSPPlWjh9gjjr4co4Lo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D9pUX1bR83krUoBesqHffutvZDbCFqXeO4HeIFX0s8ssbzbkrG+pAs/xiyeUHup/zFbctt84pBeaIHk0aUj4ikCI3VtSICSvhlpAZb4Qutwd6sqUYmOy8NdV3vBlJ/IxmPzp1Qco6/npHlosgQA5TAultturJZpDZFLaqS/OPWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mj5EMbP8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mj5EMbP8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6394CC116B1;
	Tue, 23 Apr 2024 21:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908513;
	bh=7nC1IWxTKT+pq4h51pai/fTYeSPPlWjh9gjjr4co4Lo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mj5EMbP85LFEqED7QwYnxmRoiNkn+b3cdPopgGkoLCLePyzqb5IKwOz2WuyQSy10G
	 Fbz2FueEzJNVytNFyJ96zosg+kONqEoNMVETE6ucQD6IwNJ5ijvLFB8bFnvnNajgwk
	 iV9Z0pR8DwVckn0N1a1NL8pKl1KTO/cOsBAcSmsg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gil Fine <gil.fine@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.8 099/158] thunderbolt: Do not create DisplayPort tunnels on adapters of the same router
Date: Tue, 23 Apr 2024 14:38:41 -0700
Message-ID: <20240423213859.167911640@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit c032cdd48b29549e8283c2fea99e7d91ddefebf7 upstream.

Probably due to a firmware bug Dell TB16 dock announces that one of its
DisplayPort adapters is actually DP IN. Now this is possible and used
with some external GPUs but not likely in this case as we are dealing
with a dock. Anyways the problem is that the driver tries to create a
DisplayPort tunnel between adapters of the same router which then shows
to user that there is no picture on the display (because there are no
available DP OUT adapters on the dock anymore).

Fix this by not creating DisplayPort tunnels between adapters that are
on the same router.

Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/10265
Fixes: 274baf695b08 ("thunderbolt: Add DP IN added last in the head of the list of DP resources")
Cc: Gil Fine <gil.fine@linux.intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/tb.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/thunderbolt/tb.c
+++ b/drivers/thunderbolt/tb.c
@@ -1717,6 +1717,12 @@ static struct tb_port *tb_find_dp_out(st
 			continue;
 		}
 
+		/* Needs to be on different routers */
+		if (in->sw == port->sw) {
+			tb_port_dbg(port, "skipping DP OUT on same router\n");
+			continue;
+		}
+
 		tb_port_dbg(port, "DP OUT available\n");
 
 		/*


