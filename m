Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44F6118C334;
	Wed,  3 Jul 2024 11:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005736; cv=none; b=QQmzbV9gB1S8LvEaWCd02Gc+lMvPYjmrwfHRFeB3r3jh5kvXZL6WGPS79qSB+j1xiW9PouJNKn3my4y8M7ks9Wi0UDj3e9Y4aCmeerwv2SsbtzGpKS6HVDW+04D4wca/xtPGkdEKdccUEmEyDWq89CqGSHQWrajIOoEXbTKMiDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005736; c=relaxed/simple;
	bh=L756DJeL4BljDFdUKNu76S+aICYz9u+Zqt8hF/TcWFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HWsztv9nMPa9phDZMrjTAvKYeZ2kBxPKWyB/Y1bj7pRkQ8OI0Wf4FmDW4jGrGdzdTquxLhBHHDid3+0PNH+zATmHJuVMX3dJ7aeHsSbJUhk+GqAaZATrG8KrgTxZxTisy2IdIvjSp1/cSkwbCg1SkFxrVZBDrDzcbLWj3SQkUVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wkj4ot5J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wkj4ot5J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFBFBC2BD10;
	Wed,  3 Jul 2024 11:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005736;
	bh=L756DJeL4BljDFdUKNu76S+aICYz9u+Zqt8hF/TcWFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wkj4ot5JPSSpiSB4rLAc/+/foOvjhiPuUTr/eKq6e1lbKtBnwQsrzK50VMhbH0+6p
	 fK5sP0Y+wNefpf1wpUqcD8P96CE2e5Zq+z6a4SX/OxqP286qjHPd60r4Ab1ZEJBLIN
	 FUqjFzTUVTfdJSE22/jHLD9UrSHy3mD20DfxTJSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.15 148/356] Bluetooth: qca: Fix error code in qca_read_fw_build_info()
Date: Wed,  3 Jul 2024 12:38:04 +0200
Message-ID: <20240703102918.701179155@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

commit a189f0ee6685457528db7a36ded3085e5d13ddc3 upstream.

Return -ENOMEM on allocation failure.  Don't return success.

Fixes: cda0d6a198e2 ("Bluetooth: qca: fix info leak when fetching fw build id")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btqca.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/bluetooth/btqca.c
+++ b/drivers/bluetooth/btqca.c
@@ -147,8 +147,10 @@ static int qca_read_fw_build_info(struct
 	}
 
 	build_label = kstrndup(&edl->data[1], build_lbl_len, GFP_KERNEL);
-	if (!build_label)
+	if (!build_label) {
+		err = -ENOMEM;
 		goto out;
+	}
 
 	hci_set_fw_info(hdev, "%s", build_label);
 


