Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 628241AC8AE;
	Thu, 15 Aug 2024 13:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729688; cv=none; b=BxlwOpBSyyHzZ4HaSY5capHqgIR/XDyJ7MvXUieDgNisXNN/mni2gzQmxUQzmBmdbL6WWUUH1CyGaMqht61QwD8ELDrCQ5zvXmHb4tUDIM3L4lbNagiT/DUwDWqbjv5Ft74GKeU9zYA2HmPUA9Z1RbDJOlc/oYFwPSc3CqVP/XE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729688; c=relaxed/simple;
	bh=SYYIp813p7WoKze7j9hPE64swJS4PtIqfY1mUm6EZkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KlDtaVFO1MNOTbTGQGlZkwK/XFVuCtA4gC2hZlTOiMiERVNtZHvgD+WFeapbFf3OIDHtUggxT7S2ImxxDmklXPSqyy8cUO+rHSdQMzihVBDuOiLb1WJkjU1zKwY4ybPyz4zM6FphtC8gpEG2Gm9ctEOppTChuOnNiqKSc3cloLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rk3AXqwb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rk3AXqwb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E07EFC32786;
	Thu, 15 Aug 2024 13:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729688;
	bh=SYYIp813p7WoKze7j9hPE64swJS4PtIqfY1mUm6EZkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rk3AXqwb9Eq10nczTQy4bigT6/Qjh8+DJTS/DThm2VgrVN7QoB/orFuyxL5N2rtZE
	 Tl6pj27YANg59BDMOLAXuqppZHFpHJELEhnsER1NGEaH6DPKwFZsWKnbq7w22IFBju
	 8KfJPMJX0hS9rssLPyvZXcMwRGDscfyti1+zc6mo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 5.15 177/484] char: tpm: Fix possible memory leak in tpm_bios_measurements_open()
Date: Thu, 15 Aug 2024 15:20:35 +0200
Message-ID: <20240815131948.252548532@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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


