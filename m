Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6DA81AF0A5;
	Tue, 15 Oct 2024 12:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728996827; cv=none; b=YNGZtz6b2T5iAPXQkNeLyZN9QdjmE3yWmG2kD/QFtnv9F06S2NXjlxv35n1X5JyjEOQZemdZvNESMHJH7UtaMjF+AIvQKf4bEoVjC3+ryIgEXVHcrNDDKgcByHvCvNd5WJTzB3VQaPiFVWwnNJsuBEt2PhCgthAbNM40om6bMNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728996827; c=relaxed/simple;
	bh=ZDGduTByK6LOmsBls590EqrN6jC+VuzSUOW1zDvew1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gIiDO12b992mJGrn/8NUVia9PAShEvVpKONT7XoEVD+vozWnJRMXkOMMqHewF2KQQdG5o+Uv+XK8p1+pLZPYSxpySIDPniGpOdjmGbz0bSpl7bDMB8eG+0ukv03Uq06K1yzwkO4M8nLPN4JvihU71xgUngyC4RhaMx7YKG/7r3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D7dP8oWh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D7dP8oWh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5BD2C4CEC6;
	Tue, 15 Oct 2024 12:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728996827;
	bh=ZDGduTByK6LOmsBls590EqrN6jC+VuzSUOW1zDvew1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D7dP8oWhY9At+2ygqfw7plR1ilQP1q4sVZMa3NFbtR7Y5H+C4W5o1awDHHXIS04zN
	 GL6F2lWMVSYZj54ZOVs6k7hT2+nVTholVLc2/4zZwKC/ceUISBn35xWikT2MVgLkfT
	 uA6uec0+xMtM4cBERtbeKVpY3LLIWEmN68dhZTLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anders Roxell <anders.roxell@linaro.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 011/518] scripts: kconfig: merge_config: config files: add a trailing newline
Date: Tue, 15 Oct 2024 14:38:35 +0200
Message-ID: <20241015123917.271005881@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 63c8565206a4..d7d5c58b8b6a 100755
--- a/scripts/kconfig/merge_config.sh
+++ b/scripts/kconfig/merge_config.sh
@@ -150,6 +150,8 @@ for ORIG_MERGE_FILE in $MERGE_LIST ; do
 			sed -i "/$CFG[ =]/d" $MERGE_FILE
 		fi
 	done
+	# In case the previous file lacks a new line at the end
+	echo >> $TMP_FILE
 	cat $MERGE_FILE >> $TMP_FILE
 done
 
-- 
2.43.0



