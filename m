Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 723717461
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:06:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8F2EC433C7;
	Sun, 17 Sep 2023 20:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694981206;
	bh=CoDla67E2KTpErJuLyOZc/REx67UTwKy4aJABHsKSN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uk+COaFAtvCGTTRcu6duxiwEwTDCfeIQU6M9bpX2g5PlNTPpeQe1+dKUaZVzTyA19
	 tUbUR72A97fxIPCtYl3wj17/+ai41K/9cAZAo+iqC21ahHKUMYfRxn2YhRynCB5LSh
	 1moTlyXnBkrmlqWndY61bjjHWn8i9RPZxDEQbuXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Matthew Garrett <mgarrett@aurora.tech>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 058/219] tpm_crb: Fix an error handling path in crb_acpi_add()
Date: Sun, 17 Sep 2023 21:13:05 +0200
Message-ID: <20230917191043.115814523@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191040.964416434@linuxfoundation.org>
References: <20230917191040.964416434@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 9c377852ddfdc557b1370f196b0cfdf28d233460 ]

Some error paths don't call acpi_put_table() before returning.
Branch to the correct place instead of doing some direct return.

Fixes: 4d2732882703 ("tpm_crb: Add support for CRB devices based on Pluton")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Matthew Garrett <mgarrett@aurora.tech>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/tpm_crb.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
index db0b774207d35..f45239e73c4ca 100644
--- a/drivers/char/tpm/tpm_crb.c
+++ b/drivers/char/tpm/tpm_crb.c
@@ -775,12 +775,13 @@ static int crb_acpi_add(struct acpi_device *device)
 				FW_BUG "TPM2 ACPI table has wrong size %u for start method type %d\n",
 				buf->header.length,
 				ACPI_TPM2_COMMAND_BUFFER_WITH_PLUTON);
-			return -EINVAL;
+			rc = -EINVAL;
+			goto out;
 		}
 		crb_pluton = ACPI_ADD_PTR(struct tpm2_crb_pluton, buf, sizeof(*buf));
 		rc = crb_map_pluton(dev, priv, buf, crb_pluton);
 		if (rc)
-			return rc;
+			goto out;
 	}
 
 	priv->sm = sm;
-- 
2.40.1



