Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA1A322C8A;
	Mon, 27 Oct 2025 19:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593566; cv=none; b=WtBpFtWXhLEXRT37Vc/MjBkCYeczWoKAFzpaVeqhI+TiokOMaED/9Qt84CDtto8OZLGjcsitymmVXtEAsS3teIYLuGxcSFdiAZGcdsy0YooO9uMs71L16oqCn2gDV9myHlWEfo2ILm6OpQMDauhLxrxj9KyQHbIO8C8kkPyspsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593566; c=relaxed/simple;
	bh=FfUqvul/ai3+8Ja9UatsOFA0kxOnSSWJf2YiKTgsYrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ij/q1WWIIS5eZf4X77Q0ue5mlhuKhj7yO1tdFXjZInSEwbQzauzGLLXeCq/aRWzi3i3Pc0uP0+WzbRySTjlzxIY83iarNaYaPgGdFe8OkgZQulbVyrsLMv/6GpBo0yOH2p6OwO5JOUqwWH8ZG20lsgMuEW9ECiqEgMuVeLMGGWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lRHe6XQe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lRHe6XQe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E60CC4CEF1;
	Mon, 27 Oct 2025 19:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593566;
	bh=FfUqvul/ai3+8Ja9UatsOFA0kxOnSSWJf2YiKTgsYrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lRHe6XQeESi5oO/Pqu0ibP9GaupkGTyDbgwNV1Ligik0uL+JRcixzfqSjp8YVEtRM
	 Woz92PjFBUzawzcRrz1d9txKAe4lvzwXowTsXtna3xCkc1p0NscZgxGBM+0vrqaSxw
	 LKlp1tidLiN5Bf28DO412TT0l4FLiH9mY2RABKCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ma Ke <make24@iscas.ac.cn>,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: [PATCH 6.17 174/184] staging: gpib: Fix device reference leak in fmh_gpib driver
Date: Mon, 27 Oct 2025 19:37:36 +0100
Message-ID: <20251027183519.608077240@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

commit b1aabb8ef09b4cf0cc0c92ca9dfd19482f3192c1 upstream.

The fmh_gpib driver contains a device reference count leak in
fmh_gpib_attach_impl() where driver_find_device() increases the
reference count of the device by get_device() when matching but this
reference is not properly decreased. Add put_device() in
fmh_gpib_detach(), which ensures that the reference count of the
device is correctly managed.

Found by code review.

Cc: stable <stable@kernel.org>
Fixes: 8e4841a0888c ("staging: gpib: Add Frank Mori Hess FPGA PCI GPIB driver")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/gpib/fmh_gpib/fmh_gpib.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/staging/gpib/fmh_gpib/fmh_gpib.c
+++ b/drivers/staging/gpib/fmh_gpib/fmh_gpib.c
@@ -1517,6 +1517,11 @@ void fmh_gpib_detach(struct gpib_board *
 					   resource_size(e_priv->gpib_iomem_res));
 	}
 	fmh_gpib_generic_detach(board);
+
+	if (board->dev) {
+		put_device(board->dev);
+		board->dev = NULL;
+	}
 }
 
 static int fmh_gpib_pci_attach_impl(struct gpib_board *board,


