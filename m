Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B8881422A8;
	Mon, 12 Aug 2024 16:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723478839; cv=none; b=mHX1jKcu5l0ObQfGVM1QMgU1yy4ADaTk0J/Dz+XnjazjcPiqtxFze3JsOiilvV3/l0Il8xUjnbQZDY/22ILsq2yf6g7JWIRRdQOI9hHOxYaQyhbWCwxQ/frw9bTLPm8zPV33QGLFcnHofP600u169vsSUVpqg47jKeRUfjpjBx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723478839; c=relaxed/simple;
	bh=We13SJTMEsCgd7v3K4dK51ye7voYZEAgDR3lQ7n7eIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iy437YRsmlQBLrJWCWk71acuh0IxRZyld+a7bdJbhcrg171W2s8f8sBDTjEV8oNdSzzqhqlyIbla7SqOEkn55PnnfrLk1iR2A1xsf5lwHtJ3F1AL3nl3n5npU6bLEhhvwbNm0cqsv9dFWSI7+mDa5AnW+93ZqTQuI2EGGMCOLBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RyJse4uV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RyJse4uV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6DC6C32782;
	Mon, 12 Aug 2024 16:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723478839;
	bh=We13SJTMEsCgd7v3K4dK51ye7voYZEAgDR3lQ7n7eIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RyJse4uVAUquI/lwORZxrTsXEBhSBX60GBEEylB+0Eymrya/PK3jHxh0Km/Oh7i9B
	 9j+E2/2slwVEuZkr90KeqRj7S28gICdHwBfQW3M19FJPIPp3rzGD9pOqu+pM7sKGXU
	 SP3dP9JRVbkaGgvNIbPQ9KtFfe6ru1cgaJtc3PKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salvatore Bonaccorso <carnil@debian.org>,
	Tao Chen <chen.dylane@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Quentin Monnet <qmo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 051/150] Revert "bpftool: Mount bpffs when pinmaps path not under the bpffs"
Date: Mon, 12 Aug 2024 18:02:12 +0200
Message-ID: <20240812160127.136239973@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 65dd9cbafec2f6f7908cebcab0386f750fc352af which is
commit da5f8fd1f0d393d5eaaba9ad8c22d1c26bb2bf9b upstream.

It breaks the build, so should be dropped.

Reported-by: Salvatore Bonaccorso <carnil@debian.org>
Link: https://lore.kernel.org/r/ZrSe8gZ_GyFv1knq@eldamar.lan
Cc: Tao Chen <chen.dylane@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Quentin Monnet <qmo@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/bpf/bpftool/prog.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -1707,10 +1707,6 @@ static int load_with_options(int argc, c
 	}
 
 	if (pinmaps) {
-		err = create_and_mount_bpffs_dir(pinmaps);
-		if (err)
-			goto err_unpin;
-
 		err = bpf_object__pin_maps(obj, pinmaps);
 		if (err) {
 			p_err("failed to pin all maps");


