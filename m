Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3CA7223316;
	Thu, 12 Dec 2024 17:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025910; cv=none; b=W2Legj+FXN9Hz3IJr8+wImHEIgMTd8CHslJYoDfgSgX8KB60KPtDZbgkjHXSfeLJX0kRSvi+RxQj3XIldeIZM1bETCYvL/MFOB4ezyYkwvmaBFY8uAfJrWjAjEqBDePy2hipb9J+cLLLdNBqJHx6U+evSO/fR1dgTYlFw2m/i2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025910; c=relaxed/simple;
	bh=Tur8JDYGBbc056TQIGfhRNAks9D5MNgDIrx6RqgRM/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hrAzDXLoJOn1ppiGO7RNXcEBYyUI8yXIw/+WC/OI3sQlNqWNjVFv+h0VYAKWY0WpfxGy/hI4mIOh0x8nOWKJ2bcVLvDn2+ijsNW5XNGR5xVJjxKGN84V83VRZPRwDhljdG/5TlJ/4a5wdT99SKMKXVjgTJwJ1LZrSSNIvmd0XRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I+xlaoXl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I+xlaoXl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37402C4CECE;
	Thu, 12 Dec 2024 17:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025910;
	bh=Tur8JDYGBbc056TQIGfhRNAks9D5MNgDIrx6RqgRM/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I+xlaoXlZUR4u6IFHFAKSZAeF8ujaYRyftpQLSuHyJX5clE76rZAtE/ayiC4I8lja
	 hBGwn8OQK93b/6VcBh0eiSWl7kVrjOh7qOtgdzm8JtjUVMbsVPQOdQMSaxppFwqz0X
	 AOMmG8Oei0nrKGgwHPdWwoiMZp6qDqbuIpOYNW8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kinsey Moore <kinsey.moore@oarcorp.com>,
	Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.4 314/321] jffs2: Prevent rtime decompress memory corruption
Date: Thu, 12 Dec 2024 16:03:52 +0100
Message-ID: <20241212144242.387145348@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kinsey Moore <kinsey.moore@oarcorp.com>

commit fe051552f5078fa02d593847529a3884305a6ffe upstream.

The rtime decompression routine does not fully check bounds during the
entirety of the decompression pass and can corrupt memory outside the
decompression buffer if the compressed data is corrupted. This adds the
required check to prevent this failure mode.

Cc: stable@vger.kernel.org
Signed-off-by: Kinsey Moore <kinsey.moore@oarcorp.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/jffs2/compr_rtime.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/jffs2/compr_rtime.c
+++ b/fs/jffs2/compr_rtime.c
@@ -95,6 +95,9 @@ static int jffs2_rtime_decompress(unsign
 
 		positions[value]=outpos;
 		if (repeat) {
+			if ((outpos + repeat) >= destlen) {
+				return 1;
+			}
 			if (backoffs + repeat >= outpos) {
 				while(repeat) {
 					cpage_out[outpos++] = cpage_out[backoffs++];


