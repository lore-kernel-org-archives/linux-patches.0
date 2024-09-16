Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ED64156F36;
	Mon, 16 Sep 2024 12:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488539; cv=none; b=V+w8bPo/YRIlYcmIBEZe2wJNMRkRwy7ZBdMB50PY6y0EOsYnKc2kuei0cEc3GCBn2pPGrfn22oYXJ55WoNWoENGpWsuZym/Y3BvQci935+xX+gmlZV7QkfGhbtQ787qy4UXCT6wyu+feQ4pHqa8SBwZiiuFDMAjUbKBR0tspBKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488539; c=relaxed/simple;
	bh=ZEHdcTcumX4KLBxjqMbqkYu4/F0n1i+oexBV8fuWw8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T4KuQUB1bZhGjbKdPJv2q6tPaAQxR/sP2SyFrrTiAXDih8vB+/jnCH/dJ7DX11gSkbGjvHFHuiAhkktImQJfPHdxwVVF2JqHbrwTuPEeIgqcd6ROzFhHZWRcpEupElDh8rx9bbM+02qfYAs8oR/rJd70SkDxsQeJKIe0Y7OO62k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FYa2yWSd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FYa2yWSd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CB1AC4CEC4;
	Mon, 16 Sep 2024 12:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488539;
	bh=ZEHdcTcumX4KLBxjqMbqkYu4/F0n1i+oexBV8fuWw8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FYa2yWSdTEWtr1PGToeaaOAgX0PeTVUUnrTqhIqs7F9QSDjMi3AlkT66KW2rWepcb
	 +gWvyjHCtCZ2DhcPnohpGDYPBHmx8Jqc/DqgulqKtdoRr8vvI+hSSoQfrimJXN1Pe0
	 1n4wMq3sKGf2Oc0aj3QvxONxo5ldr5A3qVuhWS9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anders Roxell <anders.roxell@linaro.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 27/91] scripts: kconfig: merge_config: config files: add a trailing newline
Date: Mon, 16 Sep 2024 13:44:03 +0200
Message-ID: <20240916114225.406784950@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114224.509743970@linuxfoundation.org>
References: <20240916114224.509743970@linuxfoundation.org>
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



