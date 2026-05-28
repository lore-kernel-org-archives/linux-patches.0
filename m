Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D8BBDDC5;
	Thu, 28 May 2026 20:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999904; cv=none; b=MbPf3VrNMRLqnuAUZ77To+Z53KUAfcbrhKBONzuAz0X8YW0f/4flBR9GGVQMyfAe+FkUEKk2ir5ooyfBYwdH+rqc1zZqc8HBtSOHOzn+NcubtySYQTKP6O0CK+VqO1tHgscKuDA+R7YL2BToQMYj/Wf0o7lOML0UsFhK8X9tb5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999904; c=relaxed/simple;
	bh=9qEwe7LoafPNCbjuJDrLPUMDk/2iWbdSAKD6gTlJlI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eH5SPp+X9HbhNz+YsHIvBYsA8vZscJzKUa2a5rMNv02EDhRk0oaSlYly3N8Isttc97iyZ9V3c7UDXF9Q2C4Edi+JWXjFnu0vd2f9PCD9kBbEdEydmovpo17bLkNGwcyhWCxYHiEFO2EY/ydr0lRsCwEVhhYUfEzvrwt+wSNtA/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XLuZI+aR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XLuZI+aR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBC071F000E9;
	Thu, 28 May 2026 20:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999903;
	bh=8RsKRY9SEiFTs4pVVCVy23hNLzPnZNXsEDDrSc4yCl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XLuZI+aRz5h7g8x9HM3ugovsu8IOzHVrJm2OYeVwXFfP5JmviLIp3YruJlUvtcBP/
	 ZAl1hCA1ftK8W+pbO2ROorDOgLMjdwyllZSbcOAlxYOTBwFyv+dy/6MLxE5/vlI5Rs
	 QHxCoDDRuoJVBZn0VxLsSvviITe/gGB3ZI8fVvWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuhao Fu <sfual@cse.ust.hk>,
	Simon Trimmer <simont@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 196/377] ALSA: hda: cs35l41: Put ACPI device on missing physical node
Date: Thu, 28 May 2026 21:47:14 +0200
Message-ID: <20260528194644.082968619@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuhao Fu <sfual@cse.ust.hk>

[ Upstream commit fca7401fe37f7abc6e54147ea560f37279231137 ]

acpi_dev_get_first_match_dev() returns a refcounted ACPI device and
callers must balance it with acpi_dev_put().

cs35l41_hda_read_acpi() stores the returned ACPI device in
cs35l41->dacpi. That reference is normally released by the later
probe cleanup or the remove path, but the NULL-check on
physdev exits before either of those paths can run.

Drop the lookup reference before returning -ENODEV.

Fixes: c34b04cc6178 ("ALSA: hda: cs35l41: Fix NULL pointer dereference in cs35l41_hda_read_acpi()")
Signed-off-by: Shuhao Fu <sfual@cse.ust.hk>
Tested-by: Simon Trimmer <simont@opensource.cirrus.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260428081238.GA1659932@chcpu16
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/side-codecs/cs35l41_hda.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/hda/codecs/side-codecs/cs35l41_hda.c b/sound/hda/codecs/side-codecs/cs35l41_hda.c
index 21e00055c0c44..47263c5a021cb 100644
--- a/sound/hda/codecs/side-codecs/cs35l41_hda.c
+++ b/sound/hda/codecs/side-codecs/cs35l41_hda.c
@@ -1901,8 +1901,10 @@ static int cs35l41_hda_read_acpi(struct cs35l41_hda *cs35l41, const char *hid, i
 
 	cs35l41->dacpi = adev;
 	physdev = get_device(acpi_get_first_physical_node(adev));
-	if (!physdev)
+	if (!physdev) {
+		acpi_dev_put(adev);
 		return -ENODEV;
+	}
 
 	sub = acpi_get_subsystem_id(ACPI_HANDLE(physdev));
 	if (IS_ERR(sub))
-- 
2.53.0



