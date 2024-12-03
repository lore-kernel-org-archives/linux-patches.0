Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A15C153800;
	Tue,  3 Dec 2024 15:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241139; cv=none; b=jCZ7I7Gp1C8McZM4k/jeysjcagbq9U8iw0DSztJdLMyPxzePfPbfCUvWel27PLncHp99sLLNkuSGnlnVYgFpjbfR1TF/V+kk1CRTVPA7zRk4cNkChMFeYONq4u6V0CMB2hwfeBNXI7l+yuBjpNMlSWc8QS/FV5VoXZAO8FeiezE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241139; c=relaxed/simple;
	bh=pbEkVgW68EcuZPO/EZGig4ODWPGgklcmlzdTXZIBgLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bgKAzfUYLM6TC3KrNLLRECcTiAIhtM4SSfnuvetnpqUDROD7eiYYxoxNVRdNWUPzplQw4xtZlfG/00QEZPGOaljhUYKM8rPTW4fr7zV//81cqhxQEPW939+p04b38NboyV4w+uZqoiyUyIS6Xv5rR0JCqqNMeFKGtqn3vDzLsls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WoMtqA46; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WoMtqA46"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75225C4CECF;
	Tue,  3 Dec 2024 15:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241138;
	bh=pbEkVgW68EcuZPO/EZGig4ODWPGgklcmlzdTXZIBgLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WoMtqA465qnqvxsl9MY/S11bcingvHZcHfq9PCH+qTafaMqDf4/QXrLidQIbXDR4b
	 hssmcymm/s/NCCJqcOPZJwp5JZdG1LmraZSH14ISbZja428XMF9UBbFgftUMC8MujP
	 qLidtOiGxUuKDs7hGx/xT26S6uyero+Lm/UxZVHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Pylypiv <ipylypiv@google.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 335/826] i2c: dev: Fix memory leak when underlying adapter does not support I2C
Date: Tue,  3 Dec 2024 15:41:02 +0100
Message-ID: <20241203144756.828642738@linuxfoundation.org>
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

From: Igor Pylypiv <ipylypiv@google.com>

[ Upstream commit 48730a9d04ffccda541602d722d1ff81920a85d8 ]

Early return in i2cdev_ioctl_rdwr() failed to free the memory allocated
by the caller. Move freeing the memory to the function where it has been
allocated to prevent similar leaks in the future.

Fixes: 97ca843f6ad3 ("i2c: dev: Check for I2C_FUNC_I2C before calling i2c_transfer")
Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
[wsa: replaced '== NULL' with '!']
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/i2c-dev.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/i2c/i2c-dev.c b/drivers/i2c/i2c-dev.c
index 61f7c4003d2ff..e9577f920286d 100644
--- a/drivers/i2c/i2c-dev.c
+++ b/drivers/i2c/i2c-dev.c
@@ -251,10 +251,8 @@ static noinline int i2cdev_ioctl_rdwr(struct i2c_client *client,
 		return -EOPNOTSUPP;
 
 	data_ptrs = kmalloc_array(nmsgs, sizeof(u8 __user *), GFP_KERNEL);
-	if (data_ptrs == NULL) {
-		kfree(msgs);
+	if (!data_ptrs)
 		return -ENOMEM;
-	}
 
 	res = 0;
 	for (i = 0; i < nmsgs; i++) {
@@ -302,7 +300,6 @@ static noinline int i2cdev_ioctl_rdwr(struct i2c_client *client,
 		for (j = 0; j < i; ++j)
 			kfree(msgs[j].buf);
 		kfree(data_ptrs);
-		kfree(msgs);
 		return res;
 	}
 
@@ -316,7 +313,6 @@ static noinline int i2cdev_ioctl_rdwr(struct i2c_client *client,
 		kfree(msgs[i].buf);
 	}
 	kfree(data_ptrs);
-	kfree(msgs);
 	return res;
 }
 
@@ -446,6 +442,7 @@ static long i2cdev_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case I2C_RDWR: {
 		struct i2c_rdwr_ioctl_data rdwr_arg;
 		struct i2c_msg *rdwr_pa;
+		int res;
 
 		if (copy_from_user(&rdwr_arg,
 				   (struct i2c_rdwr_ioctl_data __user *)arg,
@@ -467,7 +464,9 @@ static long i2cdev_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		if (IS_ERR(rdwr_pa))
 			return PTR_ERR(rdwr_pa);
 
-		return i2cdev_ioctl_rdwr(client, rdwr_arg.nmsgs, rdwr_pa);
+		res = i2cdev_ioctl_rdwr(client, rdwr_arg.nmsgs, rdwr_pa);
+		kfree(rdwr_pa);
+		return res;
 	}
 
 	case I2C_SMBUS: {
@@ -540,7 +539,7 @@ static long compat_i2cdev_ioctl(struct file *file, unsigned int cmd, unsigned lo
 		struct i2c_rdwr_ioctl_data32 rdwr_arg;
 		struct i2c_msg32 __user *p;
 		struct i2c_msg *rdwr_pa;
-		int i;
+		int i, res;
 
 		if (copy_from_user(&rdwr_arg,
 				   (struct i2c_rdwr_ioctl_data32 __user *)arg,
@@ -573,7 +572,9 @@ static long compat_i2cdev_ioctl(struct file *file, unsigned int cmd, unsigned lo
 			};
 		}
 
-		return i2cdev_ioctl_rdwr(client, rdwr_arg.nmsgs, rdwr_pa);
+		res = i2cdev_ioctl_rdwr(client, rdwr_arg.nmsgs, rdwr_pa);
+		kfree(rdwr_pa);
+		return res;
 	}
 	case I2C_SMBUS: {
 		struct i2c_smbus_ioctl_data32	data32;
-- 
2.43.0



