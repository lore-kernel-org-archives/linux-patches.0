Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 820883DB97
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FXow375c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 342ACC433C8;
	Wed, 15 Nov 2023 19:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078389;
	bh=Ye+yp90M1xMMNQzhyUfjc6buqciTVwK8hrq+/S8ly5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FXow375cDDo9uj3cy0fHbpvg/Q9xt5dl0QhqydwceUe0fOdW3yqGLsdkeegXGtdUE
	 E6RXdRT/oTJNfyMkVcVJIt23zNmDiOTjlYj2TETbB4SaYC5fuoBahXX+lvdpJx5Xct
	 fDuL5d0o+weu8TGsDaJ0X+vbX9UKOtl4EkGr5Yo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sumit Garg <sumit.garg@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 293/379] modpost: fix tee MODULE_DEVICE_TABLE built on big-endian host
Date: Wed, 15 Nov 2023 14:26:08 -0500
Message-ID: <20231115192702.479594903@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 7f54e00e5842663c2cea501bbbdfa572c94348a3 ]

When MODULE_DEVICE_TABLE(tee, ) is built on a host with a different
endianness from the target architecture, it results in an incorrect
MODULE_ALIAS().

For example, see a case where drivers/char/hw_random/optee-rng.c
is built as a module for ARM little-endian.

If you build it on a little-endian host, you will get the correct
MODULE_ALIAS:

    $ grep MODULE_ALIAS drivers/char/hw_random/optee-rng.mod.c
    MODULE_ALIAS("tee:ab7a617c-b8e7-4d8f-8301-d09b61036b64*");

However, if you build it on a big-endian host, you will get a wrong
MODULE_ALIAS:

    $ grep MODULE_ALIAS drivers/char/hw_random/optee-rng.mod.c
    MODULE_ALIAS("tee:646b0361-9bd0-0183-8f4d-e7b87c617aab*");

The same problem also occurs when you enable CONFIG_CPU_BIG_ENDIAN,
and build it on a little-endian host.

This issue has been unnoticed because the ARM kernel is configured for
little-endian by default, and most likely built on a little-endian host
(cross-build on x86 or native-build on ARM).

The uuid field must not be reversed because uuid_t is an array of __u8.

Fixes: 0fc1db9d1059 ("tee: add bus driver framework for TEE based devices")
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Sumit Garg <sumit.garg@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/mod/file2alias.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index 111d5464c12df..ebc3e5a8f797e 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -1348,13 +1348,13 @@ static int do_typec_entry(const char *filename, void *symval, char *alias)
 /* Looks like: tee:uuid */
 static int do_tee_entry(const char *filename, void *symval, char *alias)
 {
-	DEF_FIELD(symval, tee_client_device_id, uuid);
+	DEF_FIELD_ADDR(symval, tee_client_device_id, uuid);
 
 	sprintf(alias, "tee:%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-%02x%02x%02x%02x%02x%02x",
-		uuid.b[0], uuid.b[1], uuid.b[2], uuid.b[3], uuid.b[4],
-		uuid.b[5], uuid.b[6], uuid.b[7], uuid.b[8], uuid.b[9],
-		uuid.b[10], uuid.b[11], uuid.b[12], uuid.b[13], uuid.b[14],
-		uuid.b[15]);
+		uuid->b[0], uuid->b[1], uuid->b[2], uuid->b[3], uuid->b[4],
+		uuid->b[5], uuid->b[6], uuid->b[7], uuid->b[8], uuid->b[9],
+		uuid->b[10], uuid->b[11], uuid->b[12], uuid->b[13], uuid->b[14],
+		uuid->b[15]);
 
 	add_wildcard(alias);
 	return 1;
-- 
2.42.0



