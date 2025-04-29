Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B045538FB0;
	Tue, 29 Apr 2025 17:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946801; cv=none; b=jIciZCudByXH2dZGJFClFWZsAt4XVAkrBGQigKiXQtRj8v701N9GIFE/XAY9IHR3T6CnmzwbwH4/LNHlcIAIOOrLIW5Ri5Q78zcfqKpWcghJ5jBKDwt5J0/KHKa8MRODvfaWIKOmng1hwahXs+bGM5vjqP07JInYzyW60e/+fUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946801; c=relaxed/simple;
	bh=pNdIv1Hx7vKcgVJHLzU7+KeNpwQQU/IA1oHbJ7DPxho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iN48shSyBAE6HNZTt2f3yEFnu8Wwdq0dpp8HzpqwzfQ6Mt9wkErzNf5weZqnyI67r6cBSU/Q3gmxujmNUaFCFxAaOThJek7jokM2L1aERds8i7yfTY07HlDpMje/k0taB5NoetHXUoinQaoXzUqnyl1SjQ/H5rviUSIXnWvfEwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KQAuwt2Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KQAuwt2Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5FABC4CEE3;
	Tue, 29 Apr 2025 17:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946801;
	bh=pNdIv1Hx7vKcgVJHLzU7+KeNpwQQU/IA1oHbJ7DPxho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KQAuwt2QynnQNzmBtkqw43JYLygtJsBOSbDz0l9sit1qnZj12JYg1U6h2xvTZzOjW
	 8hxUk0w6Ewt+uNLqq0UlDnXBfOVUNrhnLzs+d1cjrIT1ckTjxndoxkRjwBjV/+XOLc
	 5cByPbmZRYM6N0E6O6oHcZURw0GG7DQboF6wiDr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Meng <cong.meng@oracle.com>,
	Si-Wei Liu <si-wei.liu@oracle.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>
Subject: [PATCH 5.10 074/286] vdpa/mlx5: Fix oversized null mkey longer than 32bit
Date: Tue, 29 Apr 2025 18:39:38 +0200
Message-ID: <20250429161110.896651226@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Si-Wei Liu <si-wei.liu@oracle.com>

commit a6097e0a54a5c24f8d577ffecbc35289ae281c2e upstream.

create_user_mr() has correct code to count the number of null keys
used to fill in a hole for the memory map. However, fill_indir()
does not follow the same to cap the range up to the 1GB limit
correspondingly. Fill in more null keys for the gaps in between,
so that null keys are correctly populated.

Fixes: 94abbccdf291 ("vdpa/mlx5: Add shared memory registration code")
Cc: stable@vger.kernel.org
Reported-by: Cong Meng <cong.meng@oracle.com>
Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Acked-by: Eugenio Pérez <eperezma@redhat.com>
Message-Id: <20250220193732.521462-2-dtatulea@nvidia.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vdpa/mlx5/core/mr.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/vdpa/mlx5/core/mr.c
+++ b/drivers/vdpa/mlx5/core/mr.c
@@ -165,9 +165,12 @@ again:
 			klm->bcount = cpu_to_be32(klm_bcount(dmr->end - dmr->start));
 			preve = dmr->end;
 		} else {
+			u64 bcount = min_t(u64, dmr->start - preve, MAX_KLM_SIZE);
+
 			klm->key = cpu_to_be32(mvdev->res.null_mkey);
-			klm->bcount = cpu_to_be32(klm_bcount(dmr->start - preve));
-			preve = dmr->start;
+			klm->bcount = cpu_to_be32(klm_bcount(bcount));
+			preve += bcount;
+
 			goto again;
 		}
 	}


