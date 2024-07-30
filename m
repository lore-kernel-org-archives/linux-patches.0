Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31562184549;
	Tue, 30 Jul 2024 16:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358605; cv=none; b=UqKPdEFZ+QCLfGxCxOIHvHuoyK9iX+eI7blUqzMzcFgWYxy9fXy5oc8AxhcvxFMkmmE/bE1Vl9GKoCwMs3cBw26GORMMdpTwm9qoBOofeqJvhKBqMkFEg06PriQEXBD6i2/bYx46Ox2FVjbn9Ztu8r3Hlnh/aAaPMYd3OanufDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358605; c=relaxed/simple;
	bh=U81QzIDRW9gJ1TrbbYApO5o5FlYW1ThMCA0Ekltb0Qo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ri3N62cQ/7u946JTfhEQMSFYUtdqYOG0pIIOCTHzGaZVzDkK4iAXGWJrdhJAIxEeCsY74ipxPhwTg6Cei+/q+MCxBk37Mhl+FZBUejr79eFOcA14mk6eqDRPq/CIUavNjJIXrRHmtqhrhfsXbzIUkFa1npmti3b2OtQPAdwisis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xfAfpNja; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xfAfpNja"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF431C32782;
	Tue, 30 Jul 2024 16:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358605;
	bh=U81QzIDRW9gJ1TrbbYApO5o5FlYW1ThMCA0Ekltb0Qo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xfAfpNjaGJuSPIhOWm/BYdIlD8IS7UHJcJir8xWoUoZfBCJSUJhrC78btVe/ZLwuj
	 IHFh39Sq4YJx4v5OLPObXexaCaFTn51P5m4ZqJlwhmrt3IFM36AlGPNvTb3fzwu8Lq
	 ekb1KGzhIf2ztoSVtmAsueXfrAtTkfJQ+TO6rueY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.6 378/568] char: tpm: Fix possible memory leak in tpm_bios_measurements_open()
Date: Tue, 30 Jul 2024 17:48:05 +0200
Message-ID: <20240730151654.639188160@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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


