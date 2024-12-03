Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E5701FE473;
	Tue,  3 Dec 2024 15:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240166; cv=none; b=blfnEwY2DDBu2kWTF/67VkJS4Pik+E16a7ChMiFuXBLRFN5XMF5IXyOYmFiSgiJzCvtXSqRjsQZkyy5AKA6G9eyqmUjpLxuCglkPfGgt738kF5fD4MnpiPno8JvMQScyETOf1eqWo0cLislGJlLzZjcOG4cs0422EUJndM7D2Pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240166; c=relaxed/simple;
	bh=CPvGoYZ4Uh+camfrYGXRLAX42oDNDkbPs7chiEcYG9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D8wUTHZM/JPlD3s2tZ2Vh/0SJi3ytF9q4cJzO1kT850PN3DS71jS/4wZ9hdQAkl4CMTD/CRzGdEbTxo6zpBtxE4giF+wyGtm/3lP6DbglYeMEQAPM1gDd45Xc75U0P0RCRaY2mCVXBcgEG3mcRh2UOahDChjSyAD50UbonsGJrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d5Phlegk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d5Phlegk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B871DC4CED8;
	Tue,  3 Dec 2024 15:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240166;
	bh=CPvGoYZ4Uh+camfrYGXRLAX42oDNDkbPs7chiEcYG9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d5Phlegke0sLuW8p18nPb/K4gUJX2qNQuUJvOmtgKpcwV9JenhFMf+8HWsc71Zfhh
	 hFosf5erAqy2cup4EGkN5RgflInEsINomnrOwlHO77yd0GNn1HwCPTKIkQ3RgWZ+hW
	 IIbCKFa2Zzilo+KlWcXo2RKWWsS9HHD89ZHK6wXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 046/826] crypto: qat/qat_4xxx - fix off by one in uof_get_name()
Date: Tue,  3 Dec 2024 15:36:13 +0100
Message-ID: <20241203144745.260609878@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 475b5098043eef6e72751aadeab687992a5b63d1 ]

The fw_objs[] array has "num_objs" elements so the > needs to be >= to
prevent an out of bounds read.

Fixes: 10484c647af6 ("crypto: qat - refactor fw config logic for 4xxx")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Acked-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
index 9fd7ec53b9f3d..bbd92c017c28e 100644
--- a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -334,7 +334,7 @@ static const char *uof_get_name(struct adf_accel_dev *accel_dev, u32 obj_num,
 	else
 		id = -EINVAL;
 
-	if (id < 0 || id > num_objs)
+	if (id < 0 || id >= num_objs)
 		return NULL;
 
 	return fw_objs[id];
-- 
2.43.0



