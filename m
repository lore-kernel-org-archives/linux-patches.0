Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05DA277A03;
	Wed, 21 Feb 2024 13:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523290; cv=none; b=dGHoa4TcNO+X5kxHeX0+3k349a6LWfQE7dE+HRG1IU6Ah6qGID2+bMthvewqZVNplAtTa23RH22uICgE3IsHb1J0hU7KxEs7Sqrx9XxPhxDQQfRpGWMtoieMdYfIBTi3iuQ2Nc6Q+8j6I/JsEAJYQccV88aMzmJ3Ta8BIdJ5SyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523290; c=relaxed/simple;
	bh=o1yMgI+Nrf1Xo/OGw57HO7her2gBey9UbPPtteb9j4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h3cn3WWfn6lkC6enEY0xbzXdL0VLZR8lKwaq3xt1xMogpTSiQAhQ3fVxZO8TmOoL2AX2TKLVSPBhlLdXcxTD5uJBvWekFp9CPhSekGXSE4OAPysjiAxWFuAWRJE0FjWbucHDLOMMReyLU0yf7D9+54FssBORsrTOrsObe+ZAOfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gJWRxcSk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gJWRxcSk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81D25C433C7;
	Wed, 21 Feb 2024 13:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523289;
	bh=o1yMgI+Nrf1Xo/OGw57HO7her2gBey9UbPPtteb9j4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gJWRxcSkmhQTOFFN07Oh8Bg67wMsIQk+40puBRL7Y3nPJbHFd7vr1HN67MSsRr8a0
	 FMU1qJbYzCUHeLulEVUXNnZDo6Mfn68YmYWKw8H9rxxwGAosNM9/6l6cmSQIz5CA+V
	 YZe6NJg6t8+C+OR6yl46SsXx3ywZFemx7RODDrQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 5.15 362/476] HID: i2c-hid-of: fix NULL-deref on failed power up
Date: Wed, 21 Feb 2024 14:06:53 +0100
Message-ID: <20240221130021.378692812@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit 00aab7dcb2267f2aef59447602f34501efe1a07f upstream.

A while back the I2C HID implementation was split in an ACPI and OF
part, but the new OF driver never initialises the client pointer which
is dereferenced on power-up failures.

Fixes: b33752c30023 ("HID: i2c-hid: Reorganize so ACPI and OF are separate modules")
Cc: stable@vger.kernel.org      # 5.12
Cc: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/i2c-hid/i2c-hid-of.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/hid/i2c-hid/i2c-hid-of.c
+++ b/drivers/hid/i2c-hid/i2c-hid-of.c
@@ -80,6 +80,7 @@ static int i2c_hid_of_probe(struct i2c_c
 	if (!ihid_of)
 		return -ENOMEM;
 
+	ihid_of->client = client;
 	ihid_of->ops.power_up = i2c_hid_of_power_up;
 	ihid_of->ops.power_down = i2c_hid_of_power_down;
 


