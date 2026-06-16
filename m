Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 938B72F745E;
	Tue, 16 Jun 2026 16:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627663; cv=none; b=Vuaj8xPfefcEMWW2rhTIe6vxS79qz6AWgKJxarSEBDR9gRUfZYu97q2+m8XfXApl6Toyi3XGU7C6tvCrRhhSv11QVar9seaFHGZtamWA2e8NlAvjVEs7NRgWBBVJQHtog0BvcYQ6HV7HF0NzFVYlP+uHgtJVQVyND2cLuutK79w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627663; c=relaxed/simple;
	bh=rVXmsTgRwDS0oXJqFviyBtxRrY4E96jd7Ds9a/4kBJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vEerTUmWJoMwvMvOU2moUe+qLrZx9u5tV4wLnwo/tvTg5O+Kd1eLcPzN/rG5ZDnFsFGrOVe8+zSvTZQvgKoGLxlfuCu9FsL9YPNmUQAj6ZhPINBS5nUfeJH88GQGXMgXOXWMQadurzsHj7BIu9laLWLfTITon0XqB89OsgDBM9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ffyNZECK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ffyNZECK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99BFE1F000E9;
	Tue, 16 Jun 2026 16:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627662;
	bh=T9TB81g/BvNlcj60jn41lOQ5ACWnYZFLRosovmdVA/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ffyNZECKlYPZ9FkuGtjGDAOCczgTYbwTU7IAm6e+ebii2c6NxdxP768tJav7TCSt5
	 PYbXaqqotCQycQq17FgYkbDZB3MUsaHwCppQ7RUkhyW4PV7Fb6MZlZNu7yV6NeRD+R
	 CZbJAzF9Pv4W4DMLh8qZxXvnmgSPChHd6cXXnBhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.12 205/261] thunderbolt: Validate XDomain request packet size before type cast
Date: Tue, 16 Jun 2026 20:30:43 +0530
Message-ID: <20260616145054.547597238@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

From: Michael Bommarito <michael.bommarito@gmail.com>

commit a504b9f2797b739e0304d537e8aa4ce883ecce39 upstream.

tb_xdp_handle_request() casts the received packet buffer to
protocol-specific structs without verifying that the allocation
is large enough for the target type.  A peer can send a minimal
XDomain packet that passes the generic header length check but is
shorter than the struct accessed after the cast, causing out-of-
bounds reads from the kmemdup allocation.

Plumb the packet length through xdomain_request_work and validate
it against the expected struct size before each cast.

Fixes: 8e1de7042596 ("thunderbolt: Add support for XDomain lane bonding")
Fixes: cdae7c07e3e3 ("thunderbolt: Add support for XDomain properties")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/xdomain.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/thunderbolt/xdomain.c
+++ b/drivers/thunderbolt/xdomain.c
@@ -55,6 +55,7 @@ static const char * const state_names[]
 struct xdomain_request_work {
 	struct work_struct work;
 	struct tb_xdp_header *pkg;
+	size_t pkg_len;
 	struct tb *tb;
 };
 
@@ -731,6 +732,7 @@ static void tb_xdp_handle_request(struct
 	struct xdomain_request_work *xw = container_of(work, typeof(*xw), work);
 	const struct tb_xdp_header *pkg = xw->pkg;
 	const struct tb_xdomain_header *xhdr = &pkg->xd_hdr;
+	size_t pkg_len = xw->pkg_len;
 	struct tb *tb = xw->tb;
 	struct tb_ctl *ctl = tb->ctl;
 	struct tb_xdomain *xd;
@@ -762,7 +764,7 @@ static void tb_xdp_handle_request(struct
 	switch (pkg->type) {
 	case PROPERTIES_REQUEST:
 		tb_dbg(tb, "%llx: received XDomain properties request\n", route);
-		if (xd) {
+		if (xd && pkg_len >= sizeof(struct tb_xdp_properties)) {
 			ret = tb_xdp_properties_response(tb, ctl, xd, sequence,
 				(const struct tb_xdp_properties *)pkg);
 		}
@@ -816,7 +818,8 @@ static void tb_xdp_handle_request(struct
 		tb_dbg(tb, "%llx: received XDomain link state change request\n",
 		       route);
 
-		if (xd && xd->state == XDOMAIN_STATE_BONDING_UUID_HIGH) {
+		if (xd && xd->state == XDOMAIN_STATE_BONDING_UUID_HIGH &&
+		    pkg_len >= sizeof(struct tb_xdp_link_state_change)) {
 			const struct tb_xdp_link_state_change *lsc =
 				(const struct tb_xdp_link_state_change *)pkg;
 
@@ -868,6 +871,7 @@ tb_xdp_schedule_request(struct tb *tb, c
 		kfree(xw);
 		return false;
 	}
+	xw->pkg_len = size;
 	xw->tb = tb_domain_get(tb);
 
 	schedule_work(&xw->work);


