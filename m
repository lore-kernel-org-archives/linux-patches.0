Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BCC114A088;
	Tue,  3 Dec 2024 16:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242657; cv=none; b=kV0CBeMd8T/Um92ik0QWXLDcLSIL8jGKQYK/eLUU98OUoF3FuqqNVqTpQGXWBja1+gwDSl3kAAHTlVYCnOkKRx5aJFraSn350h5bObpN6/VRMzLYnEhsb1uTzpNUa4i2qMhFRjKmXlgh4JB6OT9ZbfgJ6LmmtoM3gxOWzZb2c4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242657; c=relaxed/simple;
	bh=DFEO+4fRpTYGh38B+ohgQwgNkr44D4npmP60DglHhgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nHNGRUrnN1PvPubu9bg80edpQsnOGf88okBLfPqoegFMvvgwtI6hDMGl41bmM8g0e55o4LqiRQS5Uf56ehUxOHS5fHdKz/77EZIKefIKBmzGkGTlI2uDUrsjuSWORCY/OFpkhmmfiXsZlp2z/TmckvoJ2jsVXJ0JhoSJ7FZeoak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QGA2ziuC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QGA2ziuC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8507BC4CECF;
	Tue,  3 Dec 2024 16:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242656;
	bh=DFEO+4fRpTYGh38B+ohgQwgNkr44D4npmP60DglHhgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QGA2ziuCnFGUwqg851bRoGkcTkjRB4jb4cU6Cob4YR4A+Fx2WEl8+SsEaLfGZSeNh
	 jD0Lr57T1XGshXS+KgqeAdNhzvjH0+EvNsthQb3FBNrapjctNFDKiBjBhp4KEA2Nd2
	 FvW3/BGWc4OsQ8+rFgND9E4TD7+wlxDlNveA5A48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	James Ogletree <jogletre@opensource.cirrus.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 769/826] Input: cs40l50 - fix wrong usage of INIT_WORK()
Date: Tue,  3 Dec 2024 15:48:16 +0100
Message-ID: <20241203144813.763094574@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

From: Yuan Can <yuancan@huawei.com>

commit 5c822c0ce5cc83ed4cd8394f3dc46dae8d9a681d upstream.

In cs40l50_add(), the work_data is a local variable and the work_data.work
should initialize with INIT_WORK_ONSTACK() instead of INIT_WORK().
Small error in cs40l50_erase() also fixed in this commit.

Fixes: c38fe1bb5d21 ("Input: cs40l50 - Add support for the CS40L50 haptic driver")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Reviewed-by: James Ogletree <jogletre@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20241106013549.78142-1-yuancan@huawei.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/misc/cs40l50-vibra.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/input/misc/cs40l50-vibra.c
+++ b/drivers/input/misc/cs40l50-vibra.c
@@ -334,11 +334,12 @@ static int cs40l50_add(struct input_dev
 	work_data.custom_len = effect->u.periodic.custom_len;
 	work_data.vib = vib;
 	work_data.effect = effect;
-	INIT_WORK(&work_data.work, cs40l50_add_worker);
+	INIT_WORK_ONSTACK(&work_data.work, cs40l50_add_worker);
 
 	/* Push to the workqueue to serialize with playbacks */
 	queue_work(vib->vib_wq, &work_data.work);
 	flush_work(&work_data.work);
+	destroy_work_on_stack(&work_data.work);
 
 	kfree(work_data.custom_data);
 
@@ -467,11 +468,12 @@ static int cs40l50_erase(struct input_de
 	work_data.vib = vib;
 	work_data.effect = &dev->ff->effects[effect_id];
 
-	INIT_WORK(&work_data.work, cs40l50_erase_worker);
+	INIT_WORK_ONSTACK(&work_data.work, cs40l50_erase_worker);
 
 	/* Push to workqueue to serialize with playbacks */
 	queue_work(vib->vib_wq, &work_data.work);
 	flush_work(&work_data.work);
+	destroy_work_on_stack(&work_data.work);
 
 	return work_data.error;
 }


