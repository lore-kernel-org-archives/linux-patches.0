Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A10D199E9D;
	Tue, 10 Sep 2024 10:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962977; cv=none; b=YZOKrabU3ATSPy96P7A8ZRrtXlSKNgg3WZCl3/Gi9iXWoxiKlNsEWuvIpDysQ5TLxsGjlcAzX0/sBxxQiRSxCLSXfY5dQaH6LdaU0O3QnHrB1oEci1dC6ep7wYAVIoZ/8rhCmDDp4djt8D6D8E2XpA05m27lHyUJQBM9DwEkJNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962977; c=relaxed/simple;
	bh=pdO5Yo7cZdMEL8qsoHGTdMcwPKr8t/yeqQRwoWvllyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hvAUOKE/C+/yTFYAGu0LlDtS5XDDHQlHom2j+uduz4/NfkAIPZqu7wUpdKcA8/+Xe/8HLIXaguynGd5/8+Ns3qP4aJDOqcz0XJN4PBOtcq/NQ6SgPmKWgbIr9N9jznfoI7dTP2DcvMU9OYmbrQoz+GD1jMMOh0omVEF9tjcv6ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tcq/eKp9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tcq/eKp9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2F6FC4CEC3;
	Tue, 10 Sep 2024 10:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962977;
	bh=pdO5Yo7cZdMEL8qsoHGTdMcwPKr8t/yeqQRwoWvllyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tcq/eKp9SlvZ7hpAUp8wQgz+R3RkqXWi382bO/FcygBRJq4PLBXp9qk3QUJ1VBK4W
	 CdtEwQBX/ynCLJ/36nk4HVdHIG2OyVcvXJ6rUXJHIUo5UQHwYRgNz3s8P1UDnKioKp
	 lbmFSns8UR+U/vpQlSRP4ujSqHFGaxQUatkNM/Gc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 094/192] um: line: always fill *error_out in setup_one_line()
Date: Tue, 10 Sep 2024 11:31:58 +0200
Message-ID: <20240910092601.883137615@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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
index 95ad6b190d1d..6b4faca401ea 100644
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



