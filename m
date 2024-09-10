Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9921D18EFC6;
	Tue, 10 Sep 2024 10:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964326; cv=none; b=L4QLNM7v6E0P1EWCDcGqdFZECH6NnXxEihi6gtulOmPGxeU7b/5gLUw9XdGBFIh6YmwcqFFOhRiXWv39iIQyCVVX/gSO2D5j2YkIiHAFe0ma+cZIfY86B71i1uCfsw7d5cUPr1X2iRarpVdhgjeLXW0Wn+EpQKfBK2PvnQv+1No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964326; c=relaxed/simple;
	bh=y7oCIudHPzA7Ji61rxJh8a8vdhi4ao+DZLFA/zxobQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PL/Vi7SzLSx7c2nzKv0476ZFrDwKWOkp/eTf4VdtZlTBUSxOFjzoaFntGzVP+RDD+ccpvXcvDLvCcYYhTFZfABcuUVaphmSF0JpnV294tsW2YasCvLZs7Sjy46oO+17qnY1FbBREKIAdAuawSJkMjschGhINCUBPkp1JAH089j8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=brYyZL5D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="brYyZL5D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCD03C4CEC3;
	Tue, 10 Sep 2024 10:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964326;
	bh=y7oCIudHPzA7Ji61rxJh8a8vdhi4ao+DZLFA/zxobQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=brYyZL5DSO0t5dSBp8Noo971X1GhZjoMvlNfHYnAyA3uQ0uHsj4oRSclsAkp4yZiZ
	 R1bvNE6SQg6J0wPLgsZah/W/8MyPNGdOBv26wgV5FE3a+rDa8OlM6f7+1vVpu8uxpH
	 9MoZXIzEkFVBjbUgb+Bm6tKQj+Kar++azJvqfhdU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 144/269] um: line: always fill *error_out in setup_one_line()
Date: Tue, 10 Sep 2024 11:32:11 +0200
Message-ID: <20240910092613.343632380@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 824ac4a5edd3f7494ab1996826c4f47f8ef0f63d ]

The pointer isn't initialized by callers, but I have
encountered cases where it's still printed; initialize
it in all possible cases in setup_one_line().

Link: https://patch.msgid.link/20240703172235.ad863568b55f.Iaa1eba4db8265d7715ba71d5f6bb8c7ff63d27e9@changeid
Acked-By: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/drivers/line.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/um/drivers/line.c b/arch/um/drivers/line.c
index 375200e9aba9..2ba4e0d4e26b 100644
--- a/arch/um/drivers/line.c
+++ b/arch/um/drivers/line.c
@@ -383,6 +383,7 @@ int setup_one_line(struct line *lines, int n, char *init,
 			parse_chan_pair(NULL, line, n, opts, error_out);
 			err = 0;
 		}
+		*error_out = "configured as 'none'";
 	} else {
 		char *new = kstrdup(init, GFP_KERNEL);
 		if (!new) {
@@ -406,6 +407,7 @@ int setup_one_line(struct line *lines, int n, char *init,
 			}
 		}
 		if (err) {
+			*error_out = "failed to parse channel pair";
 			line->init_str = NULL;
 			line->valid = 0;
 			kfree(new);
-- 
2.43.0



