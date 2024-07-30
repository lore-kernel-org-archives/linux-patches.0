Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB2981A76A4;
	Tue, 30 Jul 2024 17:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360005; cv=none; b=PSIHzxpgyz1FF7odXSVPV4VmKKDLGG59gCvxhK4zOcsHcmjhOhaXHzAk+L3G0EbDdvkGKKD684WmK0f3t1naDUbN8rW+pL8ENMhpvuIIrwgJPky7ZkBMYAfLoWL8CQWk8gk1AcjzeEQdwp9THVKgs4BwMk3CYlapdf0iXsxe83g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360005; c=relaxed/simple;
	bh=ofYOSbR0Y2iZ+LbKqfOhUtVwrYEq7FmbkTdjF4Altw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MSaeM8gLsOKnZcwV6OmyeGeZ0oqCrTExl89Dug8mNs+4Ju0/7Awv7VGJXDynxe765BAS5sRlH1JLgQnYGMdU1cH8UC+mlsOjsw3ZGVsu0KAZP9BuMvj/CosLR7Cmk0/G/c3MbR9ARdAixgbQbfKMUdS40Y616PEKtgGYzIe29ZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LzM7FOMw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LzM7FOMw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CB4EC32782;
	Tue, 30 Jul 2024 17:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360005;
	bh=ofYOSbR0Y2iZ+LbKqfOhUtVwrYEq7FmbkTdjF4Altw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LzM7FOMwqEwwDgD/Laob1R7Qbu9kdk60r47j+P3kiX82OcStbPwXHroXgwCTRfiYs
	 LNu6o1Tx/7Ol0XUckcmgyzJip2GVHFrLp1LBn/ln6KYgNEc4FLq2/KIohv2YzUHa6o
	 /MSBY7u77G0st5BJRhSpzBzJA2mtWwxSDpuTnxC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.10 568/809] char: tpm: Fix possible memory leak in tpm_bios_measurements_open()
Date: Tue, 30 Jul 2024 17:47:24 +0200
Message-ID: <20240730151747.208475688@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

commit 5d8e2971e817bb64225fc0b6327a78752f58a9aa upstream.

In tpm_bios_measurements_open(), get_device() is called on the device
embedded in struct tpm_chip. In the error path, however, put_device() is
not called. This results in a reference count leak, which prevents the
device from being properly released. This commit makes sure to call
put_device() when the seq_open() call fails.

Cc: stable@vger.kernel.org # +v4.18
Fixes: 9b01b5356629 ("tpm: Move shared eventlog functions to common.c")
Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/eventlog/common.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/char/tpm/eventlog/common.c
+++ b/drivers/char/tpm/eventlog/common.c
@@ -47,6 +47,8 @@ static int tpm_bios_measurements_open(st
 	if (!err) {
 		seq = file->private_data;
 		seq->private = chip;
+	} else {
+		put_device(&chip->dev);
 	}
 
 	return err;


