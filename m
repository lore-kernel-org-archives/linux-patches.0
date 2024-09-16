Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5DF15666B;
	Mon, 16 Sep 2024 12:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488187; cv=none; b=ahrLtsbQXX5coL7TmH9e6CITLKVQY+U1sq4egt2qCGeiDpP7N8sESbnsKgDjaNuZQtIAL4iaG3izobKhQvZs/vMmvv/My3jFu+NRscy4QGG8RHtYF9UATan2zTWeQbycc3GfffYJfrKZBRkw8xeDE4pkTewyB07RRUBXAHdHilo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488187; c=relaxed/simple;
	bh=FX1WhBTLhtOt63b1AmWeD6ZClcLXPT54f/5rQw3ED98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q/CO6sEavTUbXLk82On1zgIer22/fDqION/dCIp28sKp0BJOP4P39ik4Xm4hW5xny8Ql0eG7Ft59zoFSzRu5aMBmzj+YFnGSSd06zd4YrNSUUf7Bubrrm1le4KXu5vLGhiAxbAw9N6BL/WJqEvtfS2vwhi908CLZsaQibn7qBqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=thPow/C9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="thPow/C9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15C3BC4CEC4;
	Mon, 16 Sep 2024 12:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488187;
	bh=FX1WhBTLhtOt63b1AmWeD6ZClcLXPT54f/5rQw3ED98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=thPow/C9uVtFIg13B40M9ixRMALytkQ5LuC70krn5zD5xi4WBPkJNytC5k+/2VvQd
	 YwhUoqSxkLvIY0c/wgLdMvuZPb/2C8fb8t7k0MU3/1TJnnZLBXamQI4QOsXFbMkMgc
	 lFMIBKGBqJFZU0xkdGRiEXGSJjk2loo8arsokDR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anders Roxell <anders.roxell@linaro.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 025/121] scripts: kconfig: merge_config: config files: add a trailing newline
Date: Mon, 16 Sep 2024 13:43:19 +0200
Message-ID: <20240916114229.864324016@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
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

From: Anders Roxell <anders.roxell@linaro.org>

[ Upstream commit 33330bcf031818e60a816db0cfd3add9eecc3b28 ]

When merging files without trailing newlines at the end of the file, two
config fragments end up at the same row if file1.config doens't have a
trailing newline at the end of the file.

file1.config "CONFIG_1=y"
file2.config "CONFIG_2=y"
./scripts/kconfig/merge_config.sh -m .config file1.config file2.config

This will generate a .config looking like this.
cat .config
...
CONFIG_1=yCONFIG_2=y"

Making sure so we add a newline at the end of every config file that is
passed into the script.

Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/merge_config.sh | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/scripts/kconfig/merge_config.sh b/scripts/kconfig/merge_config.sh
index 902eb429b9db..0b7952471c18 100755
--- a/scripts/kconfig/merge_config.sh
+++ b/scripts/kconfig/merge_config.sh
@@ -167,6 +167,8 @@ for ORIG_MERGE_FILE in $MERGE_LIST ; do
 			sed -i "/$CFG[ =]/d" $MERGE_FILE
 		fi
 	done
+	# In case the previous file lacks a new line at the end
+	echo >> $TMP_FILE
 	cat $MERGE_FILE >> $TMP_FILE
 done
 
-- 
2.43.0



