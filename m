Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828887;
	b=J6CiE0gh9XKzkKtrdG9N6FsBshjVgq41mKmHYIAt/8aik0hS9irVpPOH1vqDNS18+PiB
	 KXB46l+ZHOU6k4RGO2TYSdd/TNVZMx54F30Mc96kKCERwIUP0NPNx8qs+DcfiosRIO+mV
	 c74Q0obGOs3yfJ/EhwH7wRDPzOOpcbFs4EOhv7mp+XgVuovj/8V1JVfiNGfEFMZd4rWRX
	 t/LJAP9BLzO64fw8YIU7MOqovvpiTjRXAFx5vaikZBE3ycssfjHHZOR5AA2A1wQw6XZKi
	 cg8W0fL4F+Tq7Y9p/HcnCZfCl2IyduMiRTDjIGhXGqvps4gt2D1M4iJjbzD5gaBrKKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828887;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fQWjSZi36CpXyW+NAW6+bNOkvqlvRNWsnkjEDrysnIs=;
	b=5dhPcI6nDT8rCpGvyie6IZoldm90iSw0rcklbDHn0zVtmCuh0/TkN5AEtim02QYGwqqH
	 zesMXU8h0j5bOLjL8ns32EXb5XMYa4awVCtHxsp2MGBHHiaXMljrS54IeInj4OCFoBlZH
	 SdhY6JVibYf6rE7rHPO9C1nctwevXELsAjp9Ohjz+zU31OwG27vIE6q45jjv2hpQ8CS/F
	 4Xoo95KEY97IYubIzb2vr+tzQf+AYYcTPZAGnySTLKlMV1rG8KNpgHQxNWXvvnJ0LlMbZ
	 1nHQUs8g7wy1uFhXtTvbctuujBBfeYcXS5+ZNUfz+tX3UNMBOHy8ph8JPIF0kDUEyYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v6UIBCZ5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43828607040A;
	Wed,  4 Nov 2026 21:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v6UIBCZ5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D671B1F000C1;
	Wed,  4 Nov 2026 21:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828887;
	bh=fQWjSZi36CpXyW+NAW6+bNOkvqlvRNWsnkjEDrysnIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v6UIBCZ5k6Mnpe6gESeerIydPbd6LR2UhXuPoDMDgPl5cfHn4NsYOKD5OFB+3JNc1
	 /puO11/6K6EQEMIxTZWy/Mx+do8YfuxxB5FptwL55PJkMKb1usIP1sYSvX72Zg3xrC
	 ykYSNelpFi1WMjFxibDn/HjmEvgPnRvAw51e9/bE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 302/547] xfs: fix xfs_rename_space_res for non-pptr filesystems
Date: Wed,  4 Nov 2026 16:08:06 -0500
Message-ID: <20261104211046.787983292@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit a800b926346c3aa2482421f5c0272280ee7d32e8 upstream.

We don't need to reserve space for a parent pointer update for an
existing target if parent pointers are disabled.  Fix this regression
(which LOLLM noticed) so that rename reservations go back to what they
were before parent pointers.

Cc: stable@vger.kernel.org # v6.10
Fixes: 5a8338c88284df ("xfs: Add parent pointers to rename")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_trans_space.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/xfs/libxfs/xfs_trans_space.c
+++ b/fs/xfs/libxfs/xfs_trans_space.c
@@ -127,10 +127,10 @@ xfs_rename_space_res(
 		if (has_whiteout)
 			ret += xfs_parent_calc_space_res(mp, src_namelen);
 		ret += 2 * xfs_parent_calc_space_res(mp, target_namelen);
-	}
 
-	if (target_exists)
-		ret += xfs_parent_calc_space_res(mp, target_namelen);
+		if (target_exists)
+			ret += xfs_parent_calc_space_res(mp, target_namelen);
+	}
 
 	return ret;
 }


