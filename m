Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C98D333F38A;
	Tue, 31 Mar 2026 16:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975218; cv=none; b=ZuvQ0hh0JbKIOytJKncwTj2OZ7YBnwyKTwht1PyCqpKqFtDBUbgA3KNlud56ODP2P7T11Sz4JkMINcQdHQ77+ApofRr/9K0zZ/ZpfyDDEl1w4r+a8c35FdrhDyNNMGy0uApuHC9tb7xdLScd8yeuRpejexw0luFPsZOz3RyDmos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975218; c=relaxed/simple;
	bh=AvG//RyjW0hxWAwXPZmJ/0zmAbrji+rOOVxcnBn8pGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rP+lLHFNGR6eHCnLJI3zvnz6Igulx5MWRlg77WhLC9Ra3iNiH5yX+lJ1M7Qec4Ci3TV8SZmFkuIh2f3rAF1pL9Ul1vmggJNE2GqgI/SoaLwkBXXJG5b6v4bxBmriorWSCvnaFYF2ujk5x/Fpx1yne3zRmHqLsZCWzJOet9ADqNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MmSU8G4o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MmSU8G4o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60B94C19423;
	Tue, 31 Mar 2026 16:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975218;
	bh=AvG//RyjW0hxWAwXPZmJ/0zmAbrji+rOOVxcnBn8pGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MmSU8G4okrIWKXWPVo+QggeeyGoojJazI41V+tbHOu4LApCym5DdLqUP/ALSbpYBw
	 bE6SNCDHNClRfWsJVhPoDTk8Hkh5pjrQWrZZQJXAaOItyXKhe1ibAK4K1fMBTfrvYC
	 dEb5UEt7s4pzcsWDD9MxTsNh7MbX8adw/th6Mrmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.19 210/342] ASoC: sma1307: fix double free of devm_kzalloc() memory
Date: Tue, 31 Mar 2026 18:20:43 +0200
Message-ID: <20260331161806.707939464@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

commit fe757092d2329c397ecb32f2bf68a5b1c4bd9193 upstream.

A previous change added NULL checks and cleanup for allocation
failures in sma1307_setting_loaded().

However, the cleanup for mode_set entries is wrong. Those entries are
allocated with devm_kzalloc(), so they are device-managed resources and
must not be freed with kfree(). Manually freeing them in the error path
can lead to a double free when devres later releases the same memory.

Drop the manual kfree() loop and let devres handle the cleanup.

Fixes: 0ec6bd16705fe ("ASoC: sma1307: Add NULL check in sma1307_setting_loaded()")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Link: https://patch.msgid.link/20260313040611.391479-1-lgs201920130244@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/sma1307.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/sound/soc/codecs/sma1307.c
+++ b/sound/soc/codecs/sma1307.c
@@ -1759,8 +1759,10 @@ static void sma1307_setting_loaded(struc
 				   sma1307->set.mode_size * 2 * sizeof(int),
 				   GFP_KERNEL);
 		if (!sma1307->set.mode_set[i]) {
-			for (int j = 0; j < i; j++)
-				kfree(sma1307->set.mode_set[j]);
+			for (int j = 0; j < i; j++) {
+				devm_kfree(sma1307->dev, sma1307->set.mode_set[j]);
+				sma1307->set.mode_set[j] = NULL;
+			}
 			sma1307->set.status = false;
 			return;
 		}


