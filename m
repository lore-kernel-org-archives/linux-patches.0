Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F3B1E7640;
	Tue, 15 Oct 2024 11:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992115; cv=none; b=SPOsMRA+thvSj7ombl0DRCNSwfiLBATXJBa+WHymEZRzD4cXcl0empHXmeO6f/669FEvRDIgQ4jqzzUa+VeQCCdL+HQHUXZKq1p6VV+TVUiX2GfHb/rkjB1I8sIzmaUO26yTfNgJCMvME29Kwrwv+fOy7BKPGbk0r+P2WBJKXT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992115; c=relaxed/simple;
	bh=2t/tc2xiZskuWtjZjmKZRFrAdFfL/PquUMcOn4hlUww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jzP/egZOI4ktQxRVYAnbcVBkbAeP2FzHyGfXI/1OiSohoV4/1MjYXdnutnErhKfbgBpSVe4r+/3KvZ399xkBtnaxV6ERn3dcKxIyEqoN65d/xCtagQi3dJ5DQbPOBndYil5GgNYikdsDwXftXomesDloNX87aOPtzg8zn8IXpd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uzNTz/fp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uzNTz/fp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E64CCC4CECE;
	Tue, 15 Oct 2024 11:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992115;
	bh=2t/tc2xiZskuWtjZjmKZRFrAdFfL/PquUMcOn4hlUww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uzNTz/fpMK3aERsHa2dphJJzv3YSYKEcrTm2wyiqrRduo923MC91itkucG9jnZ5qG
	 uAXXZu+XUnb4jTnYT2hXCP1kx7nv1oJNGHr4lcUa5eRkiSArqscQlPoru6B4X3VTJi
	 2sWN/bspy8KZ6XPRlazu8h+E3gcZ047IkkBSFgUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anders Roxell <anders.roxell@linaro.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 023/691] scripts: kconfig: merge_config: config files: add a trailing newline
Date: Tue, 15 Oct 2024 13:19:31 +0200
Message-ID: <20241015112441.254803117@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



