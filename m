Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C05E8332629;
	Thu, 30 Jul 2026 15:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426372; cv=none; b=lCf3qPHdn8FkCk87zKHeYcaBx1RibfBL7g1HvKSUz00AXzZNZWkyUbjYYSXNvDAHykyVb0UFCyu03vHa9jsWJrmBlTg3EBO89OUU2+gEN8l3jukZE66O7hR6KV1M9DeZAJoFBgm2Fw7HD8JDzw75z8VFKpYVM8Y6XFCDnvX06fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426372; c=relaxed/simple;
	bh=IaZUCcUMHqVXRH9DNHrj66pif+drqUbhg5AuEye1xzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KPzrfyPFnJdPNvsmnYCHvB8L1zxggnIQChEaEqphdDugx1bBSMcl6TPb3YSadChITLmnWAmyH2+tU+Im8diUh2pE/usc7L2Ylnp49uGFOHr2nS9dkYzdw4Cs7sAv7WK9dZjbvUQYeusFtPph2saCiLW7VqKY5QiDhtZVGTLt+s4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GcHgd3E5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GcHgd3E5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1BDA1F000E9;
	Thu, 30 Jul 2026 15:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426371;
	bh=SCFAzdkfF0zTatzRIP5SK3lK/lnPjCI0jdaOmhKCbE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GcHgd3E5CK5uZA0cXmALGbsdClzzIIFYRoMynFreOshUsJWTz9v5BVn+Nb9aR0MM4
	 mPAwsV8WDIjF4pdNs3TilNnSBZmpiMK8bXs8DRk0FwvoiFmcpbZI3sFCwI5b9quqwP
	 cSulRiSZdw6+EZVOcGP6WljEBdn77yCgqIAjJENo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.12 396/602] libceph: Reject monmaps advertising zero monitors
Date: Thu, 30 Jul 2026 16:13:08 +0200
Message-ID: <20260730141444.281669252@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>

commit 40480eee361ed9676b3f844d532ac28b47251634 upstream.

A message of type CEPH_MSG_MON_MAP contains a monmap that is sent from a
monitor to the client. This monmap contains information about the
existing monitors in the cluster. Currently, a monmap indicating that
there are zero monitors in the cluster is treated as valid. However, it
is impossible to have zero monitors in the cluster and still receive a
valid monmap from a monitor. Therefore, such a monmap must be corrupted
and should be treated as invalid. Furthermore, a monmap with a monitor
count of zero can subsequently crash the client when attempting to open
a session with a monitor in __open_session(). This happens because the
"BUG_ON(monc->monmap->num_mon < 1)" assertion in pick_new_mon() is
triggered.

This patch extends a check in ceph_monmap_decode() to also reject
arriving mon_maps with num_mon == 0 rather than only with
num_mon > CEPH_MAX_MON.

[ idryomov: drop "log output for unusual values of num_mon" part ]

Cc: stable@vger.kernel.org
Signed-off-by: Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/mon_client.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ceph/mon_client.c
+++ b/net/ceph/mon_client.c
@@ -114,7 +114,7 @@ static struct ceph_monmap *ceph_monmap_d
 
 	dout("%s fsid %pU epoch %u num_mon %u\n", __func__, &fsid, epoch,
 	     num_mon);
-	if (num_mon > CEPH_MAX_MON)
+	if (num_mon == 0 || num_mon > CEPH_MAX_MON)
 		goto e_inval;
 
 	monmap = kmalloc(struct_size(monmap, mon_inst, num_mon), GFP_NOIO);


