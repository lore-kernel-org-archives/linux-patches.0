Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24022148832;
	Fri,  6 Dec 2024 14:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496810; cv=none; b=GY0NqUsmLCuBZkD1iSbZ4cUyOR7bTFZyGfE8YcxWtCsHcCxPIUMEZZFIki8diiXecqg4Vz3Pl3GRmkxZTbJa9JXb8Z6P9zXfKdvCyvv+FZe5HBDw5KE8I6K315eVjcuT0vDLWRWKg4UJrFbQuYVVBqpv/bs8uAIvIHtu8frNL4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496810; c=relaxed/simple;
	bh=a55ftAYLNnxwzuyespmlXPsXgBCaYXMIYPW+BtxJAcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IEsaHXNfWIHjKr6zkI7eL60tfKp17siY9yNlqGB2Q0Na8pLl9Ze+YNB4uZMfS9dZVjRqKBeVjvtmy+Unv7kjH6DCsIdgcSA2YyD6ORn+h1arjYGTK35dQ/ivuk9Guiq70nePd5Uu+fmYvYxfktsFDW1R0f5hrxAsuvuaDkTHYiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x3DUUUVn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x3DUUUVn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83ABFC4CED1;
	Fri,  6 Dec 2024 14:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496810;
	bh=a55ftAYLNnxwzuyespmlXPsXgBCaYXMIYPW+BtxJAcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x3DUUUVnB2RkBUvCiCtU57HRmDnb1kxBTjK0ixKkJjzoeReMvXi6wqbiwJf6c3WyJ
	 6hvwdz+zQfVLFAuX7u7bdVddeRbvNCnCKjedMX27YHssHcbXES1eILnrA6C1b5TEFB
	 VWx+L6LIAyBMahYWzwYb56/9CbygnUPyPrVMEPoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 079/676] crypto: qat/qat_4xxx - fix off by one in uof_get_name()
Date: Fri,  6 Dec 2024 15:28:18 +0100
Message-ID: <20241206143656.453752043@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 615af08832076..403f073714450 100644
--- a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -473,7 +473,7 @@ static const char *uof_get_name(struct adf_accel_dev *accel_dev, u32 obj_num,
 	else
 		id = -EINVAL;
 
-	if (id < 0 || id > num_objs)
+	if (id < 0 || id >= num_objs)
 		return NULL;
 
 	return fw_objs[id];
-- 
2.43.0



