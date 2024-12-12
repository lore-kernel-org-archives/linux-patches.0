Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B50C6F2FE;
	Thu, 12 Dec 2024 17:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023467; cv=none; b=iR0cLJbjqSPcd8Gw5rDaDDRWvQ6upeNqsRAlg43KAuygGmwhtY2aub8+FaIKot07qrlwYsvpTvYOkt6Mf6KIh6vY2PEa+rSJw5EiYd0LQKmE6/08SdqUeJqhCZAFRGSpuuvGaAc5wSR7oBKQ6VAQ4DLNLV12Bp8Gu+oKC8rIrB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023467; c=relaxed/simple;
	bh=MmbuJJjEYOmXESSwcQ9fnC6tR9NIrrm0BOXDPiNwtac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JkV0r++ll1tFIxHB281qowYZQgJTh/B0im/bMZwLEE4TL0nrg+3tuDa2TYwv+b/xOzxpGQLfQv0U0sj7DcTgrsQ6mYnr9NFUAPKzcytrPJY3TuSpTfwAoVXI2vyXgHGt3fvJEXACxKgZ184sHl+C6JAePoz7rzYjrkN+gjVwDjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zst6hAge; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zst6hAge"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2098BC4CECE;
	Thu, 12 Dec 2024 17:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023467;
	bh=MmbuJJjEYOmXESSwcQ9fnC6tR9NIrrm0BOXDPiNwtac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zst6hAge3XsWtKkIBymBQH4C8XRIaQXbS0gJnYja+KCMmhG9ch1yD68U6R7loX9wf
	 tyH8dTSDnmJrnVrJ/lx5BQQeUKd4OTqlwsqak7xflDRiEUaxkRkp2EPCKe6upzFtS2
	 UhQtfPzxjBw1+rgec45gYyXv6Fdzro2YLjuEEGqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kinsey Moore <kinsey.moore@oarcorp.com>,
	Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.15 542/565] jffs2: Prevent rtime decompress memory corruption
Date: Thu, 12 Dec 2024 16:02:17 +0100
Message-ID: <20241212144333.280510664@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


