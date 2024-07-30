Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFEB71A6192;
	Tue, 30 Jul 2024 16:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357617; cv=none; b=BWyYnRbc45dRC94eGYfYQb8YGFiSWU90yITFXB7mcWvBC+v3P3csBF9F6Im9dVBG1iDvz608W2Y9m3OlnmTpgl7T6l1LNQhO1nsv4tDA/XfiMJtZpzY/3+LpgRBDUcRRZM++xmHKhS1MYQV7/bQ9j6yIo2AlHj7pakvvXujA4U0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357617; c=relaxed/simple;
	bh=u9SmFqfJ5OxDBeGI3SaypfMZXiZeLphbZuhdderBdcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aFOpSEOjDU9VNLQQ2h0FHa3En9TmYKBAhKq8d28E9p5Dd4Ru85aAfjQwW8jJIwRieq7n22lXoWi9KlfdZhR8zaexRMu/bQWvaoJuLPBYJJJCVr0+cM42ZoKfA0RlrAcJnlAkMD44Y5T64hOkdsjt+bKcDhOmHH2NhSQ41JL419Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OnqttdW9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OnqttdW9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D037AC32782;
	Tue, 30 Jul 2024 16:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357617;
	bh=u9SmFqfJ5OxDBeGI3SaypfMZXiZeLphbZuhdderBdcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OnqttdW9n++878O/0zBvrLmx/hgbTYFirDMJ8M0442pGOm+eC4L8TlNp2rqvA1Nh8
	 skJ3XWMf1KsOHvmSzxUhsZLIEhPweh/H0vEFPgI58Ck5BaFU5DK65Av2WXPMRSJQot
	 fmF65Q3Qt2ihJ7Jp61GGqzWJcVBNZQNUnNKlFu6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jay Buddhabhatti <jay.buddhabhatti@amd.com>,
	Michal Simek <michal.simek@amd.com>
Subject: [PATCH 6.1 309/440] drivers: soc: xilinx: check return status of get_api_version()
Date: Tue, 30 Jul 2024 17:49:02 +0200
Message-ID: <20240730151627.895468889@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

From: Jay Buddhabhatti <jay.buddhabhatti@amd.com>

commit 9b003e14801cf85a8cebeddc87bc9fc77100fdce upstream.

Currently return status is not getting checked for get_api_version
and because of that for x86 arch we are getting below smatch error.

    CC      drivers/soc/xilinx/zynqmp_power.o
drivers/soc/xilinx/zynqmp_power.c: In function 'zynqmp_pm_probe':
drivers/soc/xilinx/zynqmp_power.c:295:12: warning: 'pm_api_version' is
used uninitialized [-Wuninitialized]
    295 |         if (pm_api_version < ZYNQMP_PM_VERSION)
        |            ^
    CHECK   drivers/soc/xilinx/zynqmp_power.c
drivers/soc/xilinx/zynqmp_power.c:295 zynqmp_pm_probe() error:
uninitialized symbol 'pm_api_version'.

So, check return status of pm_get_api_version and return error in case
of failure to avoid checking uninitialized pm_api_version variable.

Fixes: b9b3a8be28b3 ("firmware: xilinx: Remove eemi ops for get_api_version")
Signed-off-by: Jay Buddhabhatti <jay.buddhabhatti@amd.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240515112345.24673-1-jay.buddhabhatti@amd.com
Signed-off-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/xilinx/zynqmp_power.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/soc/xilinx/zynqmp_power.c
+++ b/drivers/soc/xilinx/zynqmp_power.c
@@ -187,7 +187,9 @@ static int zynqmp_pm_probe(struct platfo
 	u32 pm_api_version;
 	struct mbox_client *client;
 
-	zynqmp_pm_get_api_version(&pm_api_version);
+	ret = zynqmp_pm_get_api_version(&pm_api_version);
+	if (ret)
+		return ret;
 
 	/* Check PM API version number */
 	if (pm_api_version < ZYNQMP_PM_VERSION)


