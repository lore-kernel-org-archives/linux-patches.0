Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E7333D6D6;
	Wed,  3 Dec 2025 15:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777297; cv=none; b=UymhCoQytowRyCqevd4sMwy2GnaJDZKf76gP98MpTgnU3KxnvXfSvBSl7wLpFQvmxpBh3jHMMfcLNTb2slvnJv6FAQr7cKvICmQY90+g9JxgT6jkwmLkxF8u2lj51DeU/eMYmi2DQRcvpYXjEfsfS6Ugw5I01lt/NgAQ6oFdeRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777297; c=relaxed/simple;
	bh=/Ya+bzenZJyYkfqAcPxpF47IFyfoo4uklzWyvclhBGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bs8G/QHMsDAYRCjDZ5kTiugmxX9qQ2qXIGavMBwTOpIdgKbHLsQw5MqB69JP7tMVXMjO/APxtrI36jSY7Y2An1RqjuZNBIMGZBeHXFvnDUwHvmo63T1j6A9dZVNI+nQLBb5+cMPbxn2DOwB7i3n1TidbMt3KMAcgBX8I28pt63w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1eLKr+GE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1eLKr+GE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86DFEC4CEF5;
	Wed,  3 Dec 2025 15:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777297;
	bh=/Ya+bzenZJyYkfqAcPxpF47IFyfoo4uklzWyvclhBGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1eLKr+GES2PASKJnInMGcyhbT+Df1W7QGSNvP/VvvpNV39zFqMPHqza8O0d0hFL4V
	 Lr+cPV/KaLEx0Giho4wEMQdZfTvr70Mtoej1DSiKDOW4dzluNaJBrePs/bz1Adg+aC
	 UjKwUGewrMu4MxzC+Mt2Omls0+Euqgcn0EHPU+KE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ziming zhang <ezrakiez@gmail.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.17 140/146] libceph: prevent potential out-of-bounds writes in handle_auth_session_key()
Date: Wed,  3 Dec 2025 16:28:38 +0100
Message-ID: <20251203152351.598759258@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ziming zhang <ezrakiez@gmail.com>

commit 7fce830ecd0a0256590ee37eb65a39cbad3d64fc upstream.

The len field originates from untrusted network packets. Boundary
checks have been added to prevent potential out-of-bounds writes when
decrypting the connection secret or processing service tickets.

[ idryomov: changelog ]

Cc: stable@vger.kernel.org
Signed-off-by: ziming zhang <ezrakiez@gmail.com>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/auth_x.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/ceph/auth_x.c
+++ b/net/ceph/auth_x.c
@@ -631,6 +631,7 @@ static int handle_auth_session_key(struc
 
 	/* connection secret */
 	ceph_decode_32_safe(p, end, len, e_inval);
+	ceph_decode_need(p, end, len, e_inval);
 	dout("%s connection secret blob len %d\n", __func__, len);
 	if (len > 0) {
 		dp = *p + ceph_x_encrypt_offset();
@@ -648,6 +649,7 @@ static int handle_auth_session_key(struc
 
 	/* service tickets */
 	ceph_decode_32_safe(p, end, len, e_inval);
+	ceph_decode_need(p, end, len, e_inval);
 	dout("%s service tickets blob len %d\n", __func__, len);
 	if (len > 0) {
 		ret = ceph_x_proc_ticket_reply(ac, &th->session_key,


