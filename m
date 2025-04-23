Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 008E557C9F;
	Wed, 23 Apr 2025 15:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421249; cv=none; b=P363j2OVg4pyrIYZC/yfX5T2vKvMGF6k4i63LjMJEjfUOUAT+me94LOvJBAVbEqOe5BOtZiMGx50Bp1xceclXQTvaHEytIkdrcqD8WYZprNUDyqAKPaWwrU6VnJBEgyRWx40evOjjvozO2TZH2ZtWuM4urRW2inkhmnuqg51Sq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421249; c=relaxed/simple;
	bh=yh2iXL7nrxKvWTBXzxWp7EQSeFdZ6O0SWU89ajZYbWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cALzuEQ35orVRLdLg8NfsLM7/213utFi/E2wsvrr9lyCPHQPIBB8dFx51zG8c2KsDr//gGvQ/tPHkJB3fiQ9G+JaDVpd9ggbSW/UhcR8Qn9Majbuz1rK3IKaDt0G8I7nAf9vr2C5JoauVvsDGqySm2kwvWInCS0azrboEr+pTJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=joX8j7QO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="joX8j7QO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86BDCC4CEE3;
	Wed, 23 Apr 2025 15:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421248;
	bh=yh2iXL7nrxKvWTBXzxWp7EQSeFdZ6O0SWU89ajZYbWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=joX8j7QOoGK8yMzk9m/WPy8KuHZvRAVasIS6WLCZjDaxu1scqzlau8JoHUCgH6lis
	 pso3S5a2ClCEalo6+RcZQ03+OJgBkcwAtyhmFk2FJL1l4KZ8f/Ypug3x8X+TDqt1Xf
	 IdSar628ErRiaBw13o9TiuYL2/G9YnDuKTDfSsJ8=
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
Subject: [PATCH 6.6 162/393] vdpa/mlx5: Fix oversized null mkey longer than 32bit
Date: Wed, 23 Apr 2025 16:40:58 +0200
Message-ID: <20250423142650.065800759@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -166,9 +166,12 @@ again:
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


