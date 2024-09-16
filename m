Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCB1DA95E;
	Mon, 16 Sep 2024 12:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488048; cv=none; b=NPaicXfiz3MXhIIW6zAJej2b+Ll6uQnFcrvHf37tygpvOgnAmRtXjnTTgxFYXjBlZU/TzaZFlArWi2pieQe5yKSZkHhXamfbyNhRoOhJPmVwP2Lzb0KYMAPTsjab4Ik9G1S1e1H5zUrAMGrHCMslRRa1KWtzyopYw9m1Dyw5wqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488048; c=relaxed/simple;
	bh=twrLv11AH/st8BM/Ih+vkmvge1h2CkfMJg6YmQTUSW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NS7msFMN2ys7ZluXCPIXjX+H2+O8Izgv+F9YF4JMOsgTQDAvuqy7+iToqZ50yb7Zq2Wts6tJbZrpCOt9peo+YAb1ki2twGP5/S8SnGgJss8IYDmT/3Y6b3DVqVigrFyeG9+F8PLsoPfsqVIaPctEeRR4tmObcBdjAoys6OK62q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zpEBEx+F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zpEBEx+F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 538D2C4CEC4;
	Mon, 16 Sep 2024 12:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488048;
	bh=twrLv11AH/st8BM/Ih+vkmvge1h2CkfMJg6YmQTUSW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zpEBEx+F3fCtB5VYtDzWhMpyCXsNsWjT7p+oZvLHJ0ONfU/HUzPPa8qeI/rR5WEPG
	 eO3UaLry5LPQiZ648zmZGPPFwOU70rQaFUlR63LKDbD/qE/YBW3U9YUc7XuehHwCf2
	 7hSwmW8NpbLT5ivQbPZiVm0dTE8CqmFSw+2ViwSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anders Roxell <anders.roxell@linaro.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 13/63] scripts: kconfig: merge_config: config files: add a trailing newline
Date: Mon, 16 Sep 2024 13:43:52 +0200
Message-ID: <20240916114221.520367514@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114221.021192667@linuxfoundation.org>
References: <20240916114221.021192667@linuxfoundation.org>
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
index e5b46980c22a..72da3b8d6f30 100755
--- a/scripts/kconfig/merge_config.sh
+++ b/scripts/kconfig/merge_config.sh
@@ -160,6 +160,8 @@ for ORIG_MERGE_FILE in $MERGE_LIST ; do
 			sed -i "/$CFG[ =]/d" $MERGE_FILE
 		fi
 	done
+	# In case the previous file lacks a new line at the end
+	echo >> $TMP_FILE
 	cat $MERGE_FILE >> $TMP_FILE
 done
 
-- 
2.43.0



