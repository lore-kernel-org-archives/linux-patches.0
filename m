Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB538F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:44:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32D02C433C7;
	Sun, 16 Jul 2023 20:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540268;
	bh=7SevGWtBNBLfAhivgDx35DEaHKCp+g3upyG5yE7U/Hs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sJ1qvRWctwfi2alnFCyRFzQFqxLPul7HzBsqrhIwWZRDdgNZ4MEkqmcVX097WeEur
	 ZmFTA/ygjsrtpqOm6RrnWvpQPyLKuQXHVgW5nJ2Sq6qgBsBECieh/G/Mh78iK/aF5O
	 ipd5OJE49rej+s3jREg3BsmsAgqx7Tpr5YkvVL8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 302/591] platform/x86: think-lmi: Correct System password interface
Date: Sun, 16 Jul 2023 21:47:21 +0200
Message-ID: <20230716194931.707158093@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mark Pearson <mpearson-lenovo@squebb.ca>

[ Upstream commit 97eef5983372d7aee6549d644d788fd0c10d2b6e ]

The system password identification was incorrect. This means that if
the password was enabled it wouldn't be detected correctly; and setting
it would not work.
Also updated code to use TLMI_SMP_PWD instead of TLMI_SYS_PWD to be in
sync with Lenovo documentation.

Fixes: 640a5fa50a42 ("platform/x86: think-lmi: Opcode support")
Signed-off-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20230601200552.4396-3-mpearson-lenovo@squebb.ca
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/think-lmi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/think-lmi.c b/drivers/platform/x86/think-lmi.c
index 4e6040c0a2201..3a511c0f13e45 100644
--- a/drivers/platform/x86/think-lmi.c
+++ b/drivers/platform/x86/think-lmi.c
@@ -172,7 +172,7 @@ MODULE_PARM_DESC(debug_support, "Enable debug command support");
 #define TLMI_POP_PWD (1 << 0)
 #define TLMI_PAP_PWD (1 << 1)
 #define TLMI_HDD_PWD (1 << 2)
-#define TLMI_SYS_PWD (1 << 3)
+#define TLMI_SMP_PWD (1 << 6) /* System Management */
 #define TLMI_CERT    (1 << 7)
 
 #define to_tlmi_pwd_setting(kobj)  container_of(kobj, struct tlmi_pwd_setting, kobj)
@@ -1522,11 +1522,11 @@ static int tlmi_analyze(void)
 		tlmi_priv.pwd_power->valid = true;
 
 	if (tlmi_priv.opcode_support) {
-		tlmi_priv.pwd_system = tlmi_create_auth("sys", "system");
+		tlmi_priv.pwd_system = tlmi_create_auth("smp", "system");
 		if (!tlmi_priv.pwd_system)
 			goto fail_clear_attr;
 
-		if (tlmi_priv.pwdcfg.core.password_state & TLMI_SYS_PWD)
+		if (tlmi_priv.pwdcfg.core.password_state & TLMI_SMP_PWD)
 			tlmi_priv.pwd_system->valid = true;
 
 		tlmi_priv.pwd_hdd = tlmi_create_auth("hdd", "hdd");
-- 
2.39.2



