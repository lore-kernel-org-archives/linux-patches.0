Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8284322C88;
	Sun,  7 Jun 2026 10:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827789; cv=none; b=WsygZh+8GNjV+lhrv9dPGyyFhszzIVN286Spx1cTdYLsgpx4jKc49TKC1XdF3WGCa4SzWqU9GwyHxAy8DaCri19ZupfjpiJw6aB5NGwfVVc/eFuz+jtfakfxi1w8qkYL0tN6/8cijmp94gZUzgaJshMEbk24QQ20ZwvPWpJamVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827789; c=relaxed/simple;
	bh=vEWsiuyI59lh/ujg4essS9FBLCEZ28g9KoJXkvRDjQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rTt8xf0tdcf+vSOSz43RzOdrkunSiSCDaYR59q+vw0xAUUfXw/cv00BzBW5xwB/ckYex4FqteXqlocv0wje3c+4cAm+XZSvHBpTRDZOxv6mwAVYw3G9UnN4T0fjHEXyYtPxvk2S5Qz/XhQHGtzZBfIoM71AF5A7iKZarmdVkOFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k7eGCQk9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k7eGCQk9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A70B61F00893;
	Sun,  7 Jun 2026 10:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827788;
	bh=KiRWXIk0rfhiFQ1VYZpKY28k/OrUw51A0LMa3ZgaeEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k7eGCQk9cYstSNMAgO6RyxZgGxgilnY/Wu/rRI7QhQHnOv9tXuhZBrNBk9nApI0nQ
	 tr8YvFOL46jamrMvh+vnzEHURQRFfnS3bzSYPW73rDGumS3LbrepHC2os+ibupg2wX
	 7f08DZJlJRu4O9XkBIqHPhnALSSZpsV97sKhNd2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	stable <stable@kernel.org>,
	Badhri Jagan Sridharan <badhri@google.com>
Subject: [PATCH 7.0 122/332] usb: typec: tcpm: validate VDO count in Discover Identity ACK handlers
Date: Sun,  7 Jun 2026 11:58:11 +0200
Message-ID: <20260607095732.587984545@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 8fbc349e8383125dd2d8de1c1e926279d398ab17 upstream.

Properly validate the count passed from a device when calling
svdm_consume_identity() or svdm_consume_identity_sop_prime() as the
device-controlled value could index off of the static arrays, which
could leak data.

Assisted-by: gkh_clanker_t1000
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: stable <stable@kernel.org>
Reviewed-by: Badhri Jagan Sridharan <badhri@google.com>
Link: https://patch.msgid.link/2026051350-plated-salute-0efe@gregkh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -1708,6 +1708,9 @@ static void svdm_consume_identity(struct
 	u32 vdo = p[VDO_INDEX_IDH];
 	u32 product = p[VDO_INDEX_PRODUCT];
 
+	if (cnt <= VDO_INDEX_PRODUCT)
+		return;
+
 	memset(&port->mode_data, 0, sizeof(port->mode_data));
 
 	port->partner_ident.id_header = vdo;
@@ -1728,6 +1731,9 @@ static void svdm_consume_identity_sop_pr
 	u32 product = p[VDO_INDEX_PRODUCT];
 	int svdm_version;
 
+	if (cnt <= VDO_INDEX_CABLE_1)
+		return;
+
 	/*
 	 * Attempt to consume identity only if cable currently is not set
 	 */
@@ -1751,7 +1757,7 @@ static void svdm_consume_identity_sop_pr
 	switch (port->negotiated_rev_prime) {
 	case PD_REV30:
 		port->cable_desc.pd_revision = 0x0300;
-		if (port->cable_desc.active)
+		if (port->cable_desc.active && cnt > VDO_INDEX_CABLE_2)
 			port->cable_ident.vdo[1] = p[VDO_INDEX_CABLE_2];
 		break;
 	case PD_REV20:


