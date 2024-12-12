Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C53C52054EF;
	Thu, 12 Dec 2024 16:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021464; cv=none; b=NEDrv59Ek82ickUATg9gL/yGYTfk5ZaP3UQwu15Ng4GxS+ObS9V6oVtbRBm9N3nluEHwof7yJuImuFzfUsUtZ6hz1zzUsPU+3+P5lj/Ob2/mVtq16+b5fNZK9jVyPekFPJwltXx6yoN+QRpZVi7eLdKkvVXeJTzG7x8b0k8UTyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021464; c=relaxed/simple;
	bh=Tb2dFtFW+e/lFZxQgA0k/oB2GddQCh5uKx449R5FNg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CsiEOMa8L/GPLrcggMiWcup71Sp0WQfriaaxkAqsvDILqpGn2xnEeD6vzqYkuX7jTKrbZz+r5sZellPnUUTYn6j/vZP3eHJW2vsFuYd6ttAU8+iWNlBlPVl4hm/k7Vl0Y5VPbfn85La9OYZ87Wpql2KuHOPztXaunggFKhqROBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BZcIeYxN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BZcIeYxN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32314C4CECE;
	Thu, 12 Dec 2024 16:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021464;
	bh=Tb2dFtFW+e/lFZxQgA0k/oB2GddQCh5uKx449R5FNg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BZcIeYxNqGgGFOGzp7b9KXlYan0GoiPRb8/JEQ/LMDa+zVWRxD8XJekMp++js3hS2
	 nKmIIfr5it7pLTsB3umrQdlFEyNF7cDU2G+KIDDXYyipLFno+XogidLokID8xPjUad
	 OIkBoTuSQCIYzoK8dbImbGO7WX9rEgxAVFiem/Us=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kinsey Moore <kinsey.moore@oarcorp.com>,
	Richard Weinberger <richard@nod.at>
Subject: [PATCH 6.1 743/772] jffs2: Prevent rtime decompress memory corruption
Date: Thu, 12 Dec 2024 16:01:28 +0100
Message-ID: <20241212144420.636192415@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


