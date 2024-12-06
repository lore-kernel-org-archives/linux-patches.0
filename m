Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 289EF149E0E;
	Fri,  6 Dec 2024 14:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496142; cv=none; b=MB0Qf3I2aL/tVF49xt/uz8r9z4hMAHQ2brHp9VojeJJ84xnZNbh/ILc17LoRJtg2MhLMfH4NW13+hQcQ7uFmvjv0/g8FMkdUbTBAy4bpzPXcn1JRxtzaH0H8gh8heVZ4VN5DljAFZTTgOapGkFH2BRd4syP1SQbZ6HEmviQAT5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496142; c=relaxed/simple;
	bh=7baZho2u6M5bZf4qQW/GpziT5g4d+s8xavPM8hm8kPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I2+E1Wq2xKeYYzq/H9lSPvXjIDtMzVIuqio/3QWlUklhP0xoHBX44AKikzAo75AoUNsVcj5e/1UYyv3SEd/nIkasq0DqQ8Yb4xG0QTV7ad4lDJU5e1yj5iSamAfzD9o6sB/yH1/R4WCNYkqdjpLHPjR8/8JzJJSaQrNS85+O8Rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nh7iY2XO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nh7iY2XO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9916EC4CED1;
	Fri,  6 Dec 2024 14:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496142;
	bh=7baZho2u6M5bZf4qQW/GpziT5g4d+s8xavPM8hm8kPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nh7iY2XOamLtZ/58ucj9nGyNU0wlemMlLV5wUZB+MLPSkYwXLnfy8y+KpVPxEkJlo
	 Rsz8h1tPQQyrmXNvCoaL8yGrxflM5cYqT5+8bBnntCVYNNc8kVdKcpvr2kChIm2UIt
	 qgiuQSp9MMSDUSzYoGqJiYbcY58+XmImhO1SGg78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijie Zhao <zzjas98@gmail.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Xin Zeng <xin.zeng@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 6.12 064/146] vfio/qat: fix overflow check in qat_vf_resume_write()
Date: Fri,  6 Dec 2024 15:36:35 +0100
Message-ID: <20241206143530.127325902@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

commit 9283b7392570421c22a6c8058614f5b76a46b81c upstream.

The unsigned variable `size_t len` is cast to the signed type `loff_t`
when passed to the function check_add_overflow(). This function considers
the type of the destination, which is of type loff_t (signed),
potentially leading to an overflow. This issue is similar to the one
described in the link below.

Remove the cast.

Note that even if check_add_overflow() is bypassed, by setting `len` to
a value that is greater than LONG_MAX (which is considered as a negative
value after the cast), the function copy_from_user(), invoked a few lines
later, will not perform any copy and return `len` as (len > INT_MAX)
causing qat_vf_resume_write() to fail with -EFAULT.

Fixes: bb208810b1ab ("vfio/qat: Add vfio_pci driver for Intel QAT SR-IOV VF devices")
CC: stable@vger.kernel.org # 6.10+
Link: https://lore.kernel.org/all/138bd2e2-ede8-4bcc-aa7b-f3d9de167a37@moroto.mountain
Reported-by: Zijie Zhao <zzjas98@gmail.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Xin Zeng <xin.zeng@intel.com>
Link: https://lore.kernel.org/r/20241021123843.42979-1-giovanni.cabiddu@intel.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vfio/pci/qat/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/qat/main.c b/drivers/vfio/pci/qat/main.c
index be3644ced17b..c78cb6de9390 100644
--- a/drivers/vfio/pci/qat/main.c
+++ b/drivers/vfio/pci/qat/main.c
@@ -304,7 +304,7 @@ static ssize_t qat_vf_resume_write(struct file *filp, const char __user *buf,
 	offs = &filp->f_pos;
 
 	if (*offs < 0 ||
-	    check_add_overflow((loff_t)len, *offs, &end))
+	    check_add_overflow(len, *offs, &end))
 		return -EOVERFLOW;
 
 	if (end > mig_dev->state_size)
-- 
2.47.1



