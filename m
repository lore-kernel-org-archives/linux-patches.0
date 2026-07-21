Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72A29407576;
	Tue, 21 Jul 2026 18:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657940; cv=none; b=tDmyQt4H0V0uX4ulL7XRBDCuIjdZr6o8MqelBaIxvsqYscvtoX0X62Jdv+SmQIe6O22yLEuLf2dEPjob+VlFUKU3DOXAE8HWeIwQawCOX9Z28lVjfK0EfoqV38lxPeKje3zauyehrWqfHMX4htnQrIaS7jl2LedKHU9GtcI8n9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657940; c=relaxed/simple;
	bh=rM+LIFZr04tmzq6BXnWr48G0TNmchnxU9HaiHeJkOkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=byKEfkv6n9MwHUq44fo9aIvkkpFMXYfXQMjPDnCK5dTc/6aBa2EDHXb7/jnYlaleBkhJeUmqvSWO+6Hhpln1Qt5ObwcFpCnB+4dKuPKLlIGcu3iN2sI4Ngo+wbDYLB1hD261YILhra3JuV9n3Ay0rD0eAJShiWnu48p9AtQIslM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ClKh5gRm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ClKh5gRm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C36421F00ADB;
	Tue, 21 Jul 2026 18:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657939;
	bh=MTkp5aWcVaFqWzEvBlHpTR6CTCPlkcwLx3GmaQtOdLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ClKh5gRmWO/k5Tu6F/MSX8kU4lvDh8H7y7+AfdUgofQ6w/TdRI0FGDtAUS+rLm/se
	 2S8NwhLkQVXWPHd3Cvca+762HLr+pq6tjCz/pdIno/Bf7EO2yz5/bvuaKnkQmHmmdU
	 ZUX2MBV147WtFqN1mCDvM0ltR2MZZvV9OZXLFaKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuoqi Gui <gnq25@mails.tsinghua.edu.cn>,
	Andrea Mayer <andrea.mayer@uniroma2.it>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0955/1611] seg6: validate SRH length before reading fixed fields
Date: Tue, 21 Jul 2026 17:17:51 +0200
Message-ID: <20260721152536.872429453@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nuoqi Gui <gnq25@mails.tsinghua.edu.cn>

[ Upstream commit a75d99f46bf21b45965ce39c5cfb3b8bb5ffb1aa ]

seg6_validate_srh() reads fixed SRH fields such as srh->type and
srh->hdrlen before checking that the supplied length covers the fixed
struct ipv6_sr_hdr fields.

The BPF SEG6 encap path reaches this with a BPF program-supplied pointer
and length: bpf_lwt_push_encap() and the SEG6 local BPF END_B6 and
END_B6_ENCAP actions call bpf_push_seg6_encap(), which forwards the
length to seg6_validate_srh() with no minimum-size guard.  A 2-byte SEG6
encap header can therefore make the validator read srh->type at offset 2
beyond the caller-supplied buffer.

Reject lengths shorter than the fixed SRH at the top of
seg6_validate_srh(), before any field is read.  This fixes the BPF helper
path and keeps the common validator robust.

Fixes: fe94cc290f53 ("bpf: Add IPv6 Segment Routing helpers")
Signed-off-by: Nuoqi Gui <gnq25@mails.tsinghua.edu.cn>
Reviewed-by: Andrea Mayer <andrea.mayer@uniroma2.it>
Link: https://patch.msgid.link/20260623-f01-17-seg6-srh-len-v2-1-2edc40e9e3e1@mails.tsinghua.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/seg6.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv6/seg6.c b/net/ipv6/seg6.c
index a5c4c629b788cc..0246ab6b2c95c1 100644
--- a/net/ipv6/seg6.c
+++ b/net/ipv6/seg6.c
@@ -29,6 +29,9 @@ bool seg6_validate_srh(struct ipv6_sr_hdr *srh, int len, bool reduced)
 	int max_last_entry;
 	int trailing;
 
+	if (len < sizeof(*srh))
+		return false;
+
 	if (srh->type != IPV6_SRCRT_TYPE_4)
 		return false;
 
-- 
2.53.0



