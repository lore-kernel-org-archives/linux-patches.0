Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F02B1E25FC;
	Wed,  6 Nov 2024 12:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897818; cv=none; b=pfxWAZWpC4cdN3/WfGTlalcUrW7oNlARoXAU6kSGzC6qkxy8fo/ngetpCp2u05gw4+S1I6r+TZPXqzJKCxBlcH32fgRjGOQX2/fcotxpmCv9fiw3m49BG1hBAEfRFgD9W8VdWyiuIdUnElr2y9aH+c9CwAqWo4a1/+oqJUq+d+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897818; c=relaxed/simple;
	bh=sm7QEzwbAFIUJBaLxpEgw5sUM/Fv5vDhOn50v8ypogs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GDIOmu9FbIgPEcE0zrjQsFWZP1JIgq1e8zm8nJyoLWhs9y7T5ih0skN4/MLjGBzsdn17CBwue9MjhQD+HTuZXvYQH6i68vsZhMSDxMt+heqtFs7gw7LctN7AkxNq+KBW0yJKpXQlio8hlumT3P6x8QYbTgIg8NmaExDXBnp+mWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1tG/O2KN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1tG/O2KN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 981F9C4CECD;
	Wed,  6 Nov 2024 12:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897818;
	bh=sm7QEzwbAFIUJBaLxpEgw5sUM/Fv5vDhOn50v8ypogs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1tG/O2KNmok2ZMUBRjztWGZKOgxJ86/rmIkdsEV0FCk5cQYVNyFi7TZGq17gPC52d
	 nyHn3XPZeT0+oXK9tH33IY3ZAGh3CKN8A/KKwNMma7HQtTGEjNRe/xH5cHa6JOluC9
	 U4IKiTUkDoztqA9F7hE54NgQyB4Rmomt47NV6r+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anders Roxell <anders.roxell@linaro.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 004/462] scripts: kconfig: merge_config: config files: add a trailing newline
Date: Wed,  6 Nov 2024 12:58:17 +0100
Message-ID: <20241106120331.612683155@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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



