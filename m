Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9429198E78;
	Thu, 15 Aug 2024 13:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728650; cv=none; b=PC8fJtA59TsGYV6LIG9+sQGmMbxmkstHMr5GxwhApO7lxUGFk+aQu0iNqm81/BwKsXmX0Pp7l3C/Zjpq9HGKitYcngBTFBPQNhwG7ekvWn3PFr9K7Q2bBZm0W69kqBHkKmcvTk0UhaXi7YbCggEWNngs0cKUVCdzgaKd7FiQILU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728650; c=relaxed/simple;
	bh=mvGQT3vuSxlK/BhRw7UunQodIegoSTUpkX1RDVEhWms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NSXm7CT8KEBB6coJNOgeihuYR2G4JJ88pD+YtJgpbEugl8xA8BUVwPwRzB/pOJll5xkRv2pSnYhK+hmUwkD+ODpA/K07s01UOVw6lhN8c2CNZIg5TC3KWJ9KHRUABHOud5N3Jk7L4mhYBLoP++9o+moALZs72wY9qcRHlc7I2Mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RN3WmGR1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RN3WmGR1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 214F6C32786;
	Thu, 15 Aug 2024 13:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728649;
	bh=mvGQT3vuSxlK/BhRw7UunQodIegoSTUpkX1RDVEhWms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RN3WmGR1iCEFwK/kZEX9xhwj6GZDTDmM7tFWaSCLY52O3e34gM546UX/vGuoiquXv
	 3RnfE1oRMr4GfxIgHEdMisyC7vWEwnA6EtVkJHUA5kphlBEvJVD9cdgoSk6pIk47JZ
	 G+xKxOWLCKfmlb2VJHo4wpqV5QzGxkMFAlQ9E19w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 4.19 066/196] char: tpm: Fix possible memory leak in tpm_bios_measurements_open()
Date: Thu, 15 Aug 2024 15:23:03 +0200
Message-ID: <20240815131854.599330098@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -52,6 +52,8 @@ static int tpm_bios_measurements_open(st
 	if (!err) {
 		seq = file->private_data;
 		seq->private = chip;
+	} else {
+		put_device(&chip->dev);
 	}
 
 	return err;


