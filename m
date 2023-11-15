Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B0D41A80
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PQR41fE7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FBB2C433C9;
	Wed, 15 Nov 2023 19:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076810;
	bh=1553HxgxZqpd+nep8m985hhmHVNWwVSsES4dVkcM5fk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PQR41fE7A4Ff6D05Jq39PD8VdBZtpXU6vZR1PdqHT7Y2u00sQWFvD8bunZIgCuoEW
	 Xi6IMp9zhxgB9/lJCNWzX1lCqnbHaFQN/ISS3ynKKgRGaXR+O6w6MPHAPEkqL1wj6c
	 ZfgO1Ajy/xi1+Dt+iF3hWXSepDDYTia9pgf5daq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 430/550] modpost: fix ishtp MODULE_DEVICE_TABLE built on big-endian host
Date: Wed, 15 Nov 2023 14:16:54 -0500
Message-ID: <20231115191630.577200869@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit ac96a15a0f0c8812a3aaa587b871cd5527f6d736 ]

When MODULE_DEVICE_TABLE(ishtp, ) is built on a host with a different
endianness from the target architecture, it results in an incorrect
MODULE_ALIAS().

For example, see a case where drivers/platform/x86/intel/ishtp_eclite.c
is built as a module for x86.

If you build it on a little-endian host, you will get the correct
MODULE_ALIAS:

    $ grep MODULE_ALIAS drivers/platform/x86/intel/ishtp_eclite.mod.c
    MODULE_ALIAS("ishtp:{6A19CC4B-D760-4DE3-B14D-F25EBD0FBCD9}");

However, if you build it on a big-endian host, you will get a wrong
MODULE_ALIAS:

    $ grep MODULE_ALIAS drivers/platform/x86/intel/ishtp_eclite.mod.c
    MODULE_ALIAS("ishtp:{BD0FBCD9-F25E-B14D-4DE3-D7606A19CC4B}");

This issue has been unnoticed because the x86 kernel is most likely built
natively on an x86 host.

The guid field must not be reversed because guid_t is an array of __u8.

Fixes: fa443bc3c1e4 ("HID: intel-ish-hid: add support for MODULE_DEVICE_TABLE()")
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Thomas Weißschuh <linux@weissschuh.net>
Tested-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/mod/file2alias.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index 70bf6a2f585ce..6583b36dbe694 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -1401,10 +1401,10 @@ static int do_mhi_ep_entry(const char *filename, void *symval, char *alias)
 /* Looks like: ishtp:{guid} */
 static int do_ishtp_entry(const char *filename, void *symval, char *alias)
 {
-	DEF_FIELD(symval, ishtp_device_id, guid);
+	DEF_FIELD_ADDR(symval, ishtp_device_id, guid);
 
 	strcpy(alias, ISHTP_MODULE_PREFIX "{");
-	add_guid(alias, guid);
+	add_guid(alias, *guid);
 	strcat(alias, "}");
 
 	return 1;
-- 
2.42.0



