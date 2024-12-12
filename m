Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 291A7226542;
	Thu, 12 Dec 2024 16:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020634; cv=none; b=Uv/Egm3AdMFDeZs1bEsXNfumlrzL21w/nGhpZvEVBncUjJZKdNfHKdS5N1osCZTNJ+HLaYFMEO0pZui7PvCAJLHbZ4/q87rXYuOrOuRA3sOIXJ7f1mOpd0rH+Pb3DChdID6ozzgWO1FvPuYKoTZ29qZ8tZBNLZcO3/qhmyZFkQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020634; c=relaxed/simple;
	bh=9QRiMLeISc9L9udaBROp7HWmtHUlhuyGRpuiXFShN/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SfTXFQCcRcRFTAUhWlian3UvIGpDf4vLSb4jV9Ih0NvVLc8Zy/p7qp7hLRhChzalYCf6TmPUBKJeOY6poayx9E5/aBeaMKalEMIBjvS5waPJ+D9+73tNOtTpxX8ELmQUKrlmpWKu41v/g/o1SPOPwvbLg6RSBbZZf3qZhu1MNN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gDvAmz/b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gDvAmz/b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DC6AC4CECE;
	Thu, 12 Dec 2024 16:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020633;
	bh=9QRiMLeISc9L9udaBROp7HWmtHUlhuyGRpuiXFShN/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gDvAmz/bsQrfF2lbb3pPnHoCxYRr1XYx/3DWbWnk9LXokdE9DeK4AL4Ocg6ZPtx3H
	 M7MMF571nZ73CQTvd+8mkQg4Dxc/8W0WvICoCkUmhZMdAlDWgNYEH7Ad860i7NNjEN
	 NYoguvUGzmBs0qNKF5OGcb+/ucUyk+MJNf9ZbKPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.1 490/772] fs/proc/kcore.c: Clear ret value in read_kcore_iter after successful iov_iter_zero
Date: Thu, 12 Dec 2024 15:57:15 +0100
Message-ID: <20241212144410.202124980@linuxfoundation.org>
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

From: Jiri Olsa <jolsa@kernel.org>

commit 088f294609d8f8816dc316681aef2eb61982e0da upstream.

If iov_iter_zero succeeds after failed copy_from_kernel_nofault,
we need to reset the ret value to zero otherwise it will be returned
as final return value of read_kcore_iter.

This fixes objdump -d dump over /proc/kcore for me.

Cc: stable@vger.kernel.org
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Fixes: 3d5854d75e31 ("fs/proc/kcore.c: allow translation of physical memory addresses")
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/r/20241121231118.3212000-1-jolsa@kernel.org
Acked-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/kcore.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/proc/kcore.c
+++ b/fs/proc/kcore.c
@@ -585,6 +585,7 @@ read_kcore_iter(struct kiocb *iocb, stru
 					ret = -EFAULT;
 					goto out;
 				}
+				ret = 0;
 			/*
 			 * We know the bounce buffer is safe to copy from, so
 			 * use _copy_to_iter() directly.


