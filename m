Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 760CD1DB148;
	Thu, 17 Apr 2025 18:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913346; cv=none; b=dSufBtKfhyYGgH3kQsbyQKg/kzDlwqUKFJMwjQrgITmWWqVULAyIm4nNclb479YAmFbL0DykaxIiEgCBa6YQn5F9S0W1xcBrZljEL8Itt4+OKds+nZPUezxndJz6JBUUrpgB9D7NVfyuqZ8YutBk1OPJ+xaxG4MFovkJ5o7mIoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913346; c=relaxed/simple;
	bh=O74An4/sZz+YRepuhM2bR2w3JnVnCT2sNP+vRy7az/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gPeBepcdVmTB59LHxwAfZeMdWO77E1OJkqewdMOnNq0D5k/ntav6kLCBEo2OmU6bTuWcHzqXgk3/qLtym3vbyaXn8MbF/MQ3CXKpcj8vEqOjrGvLqHJYhVrbIa6lYvVIEw/ztTtHBhcg+6CV8CMeEdKaHvM81uPn86fGskYiMD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UihfQeC+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UihfQeC+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF5C7C4CEE4;
	Thu, 17 Apr 2025 18:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913346;
	bh=O74An4/sZz+YRepuhM2bR2w3JnVnCT2sNP+vRy7az/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UihfQeC+BHpo7Vkry9gl1HKkvV0jR9cwv5Uzn5pdkh7xDb9UX/psjAzpE+9huN5C7
	 zxRXlx6+EAZFbd2fJjHdiUwxHSnLBywpOqpFMXz/Fa0ADWY4kC/2mLfF1+rB0Dt3zc
	 cLyMZBTQ5lF1HApC5ZQXQHOHJIIl0SPNA9bMwWu4=
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
Subject: [PATCH 6.14 309/449] vdpa/mlx5: Fix oversized null mkey longer than 32bit
Date: Thu, 17 Apr 2025 19:49:57 +0200
Message-ID: <20250417175130.548728458@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -190,9 +190,12 @@ again:
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


