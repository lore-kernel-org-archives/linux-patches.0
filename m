Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C2C1E89C;
	Tue, 27 May 2025 17:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366366; cv=none; b=Mq4yIhn11MC9FRNhMGOB8zu7GmEEF5j8XMIzp9aifr2thqmYhCFRnIDInz4vBPHLSSarSO1n/ru9m08mIkREYFdJwc7QHvaWhsHJjYHsSFqEBH4GSuypHJpc8N04z4s1pD74uCvBijobuI84BwnbvUYkMezlJ/0FSxZPAvARA64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366366; c=relaxed/simple;
	bh=j1v1aNGU7WqOpb8ghg6KPB2ahRMtfNavj4IyRqCD0iU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lJ9v5HxV3xb9398fMjXrqK7kN+BGuRQ04wx7GUp3o+8INEQP1pQ4/GQI+RvX6tvfzc0b9yxdDdrex7F6X5cyTJz/RP09PZjxKccwJGSqfY7kHsvXma6kNBPABgQW9Hs95UBdQSPN1dAcZqEpFrdo2wCwmI9+T39Z6F8I1pTCCn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FxjgP/qW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FxjgP/qW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90803C4CEE9;
	Tue, 27 May 2025 17:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366366;
	bh=j1v1aNGU7WqOpb8ghg6KPB2ahRMtfNavj4IyRqCD0iU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FxjgP/qWHMXub4zXhYN7HmCFXMI2uHodM5VWFUGof95Ti61xC43ThQ00H3hzgBOKZ
	 qYGYrII3IWTyn5EelsZIhEOnhZCSCkSXmihksYWKLE0xSUlipUcb5jdh0kt7JBUup4
	 EAV8y9kjf5vKjLtZSjgcsdfl7bIRAqSaFKMaZEec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Gomez <da.gomez@samsung.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 044/783] kconfig: merge_config: use an empty file as initfile
Date: Tue, 27 May 2025 18:17:21 +0200
Message-ID: <20250527162514.928568815@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Gomez <da.gomez@samsung.com>

[ Upstream commit a26fe287eed112b4e21e854f173c8918a6a8596d ]

The scripts/kconfig/merge_config.sh script requires an existing
$INITFILE (or the $1 argument) as a base file for merging Kconfig
fragments. However, an empty $INITFILE can serve as an initial starting
point, later referenced by the KCONFIG_ALLCONFIG Makefile variable
if -m is not used. This variable can point to any configuration file
containing preset config symbols (the merged output) as stated in
Documentation/kbuild/kconfig.rst. When -m is used $INITFILE will
contain just the merge output requiring the user to run make (i.e.
KCONFIG_ALLCONFIG=<$INITFILE> make <allnoconfig/alldefconfig> or make
olddefconfig).

Instead of failing when `$INITFILE` is missing, create an empty file and
use it as the starting point for merges.

Signed-off-by: Daniel Gomez <da.gomez@samsung.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/merge_config.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/kconfig/merge_config.sh b/scripts/kconfig/merge_config.sh
index 0b7952471c18f..79c09b378be81 100755
--- a/scripts/kconfig/merge_config.sh
+++ b/scripts/kconfig/merge_config.sh
@@ -112,8 +112,8 @@ INITFILE=$1
 shift;
 
 if [ ! -r "$INITFILE" ]; then
-	echo "The base file '$INITFILE' does not exist.  Exit." >&2
-	exit 1
+	echo "The base file '$INITFILE' does not exist. Creating one..." >&2
+	touch "$INITFILE"
 fi
 
 MERGE_LIST=$*
-- 
2.39.5



