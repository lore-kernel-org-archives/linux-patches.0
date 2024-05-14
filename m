Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 509CF12DDB8;
	Tue, 14 May 2024 11:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686688; cv=none; b=QEnjgjVkNAvo2V/F+cfV5L5bqrZt9FDz6vbTud13IwkD4jplG18s7uPsU1yrqbfj2+mAYDrd637hOyffgNdwnJhefB4HjPqlXX9Y8h831RKsYjLPiUy3j/PaLechDXK6+SUoK93rcQN0nuy4+bYHXUPbQyKpWXQIQuV0EMPpk9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686688; c=relaxed/simple;
	bh=Oz/5n6+rIJKqyMHQJ0Jop2Lyh89A8W8acVreE1bjOn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=izHQMehSSmy5/y5sUZv60qN6+CAId2yVxMf2NfknOoVAyGGwYha0SPUFo9SfSsgk9xR1yjjfRtb6OmhxPw4KtnZpJn62/K4ArTYpvf3PkOvaqO2qZSxLF7CTfDbcrGvJCdHOuah3bk9H42vN4ptjbe1aE+r02EEfBNjpurXPqdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xAkTJkta; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xAkTJkta"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFC8BC2BD10;
	Tue, 14 May 2024 11:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686688;
	bh=Oz/5n6+rIJKqyMHQJ0Jop2Lyh89A8W8acVreE1bjOn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xAkTJktanSEwA5idVCKLS58ioTo1fo8WpyVVmQF7c9UgoSxH20YVEPx/TbwLvws7S
	 Qv827W9Tpqs71Gu46vHvZtKQNxigWKG/U0tH19+Zmm7gHIhM3G7ADuyl+DYMwSoGmv
	 327HYZichJRd0hMGGCkC0NIe74QN3RlfkXUX5Ehs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lakshmi Yadlapati <lakshmiy@us.ibm.com>,
	Eddie James <eajames@linux.ibm.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.1 225/236] hwmon: (pmbus/ucd9000) Increase delay from 250 to 500us
Date: Tue, 14 May 2024 12:19:47 +0200
Message-ID: <20240514101028.900092602@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

From: Lakshmi Yadlapati <lakshmiy@us.ibm.com>

commit 26e8383b116d0dbe74e28f86646563ab46d66d83 upstream.

Following the failure observed with a delay of 250us, experiments were
conducted with various delays. It was found that a delay of 350us
effectively mitigated the issue.

To provide a more optimal solution while still allowing a margin for
stability, the delay is being adjusted to 500us.

Signed-off-by: Lakshmi Yadlapati <lakshmiy@us.ibm.com>
Link: https://lore.kernel.org/r/20240507194603.1305750-1-lakshmiy@us.ibm.com
Fixes: 8d655e6523764 ("hwmon: (ucd90320) Add minimum delay between bus accesses")
Reviewed-by: Eddie James <eajames@linux.ibm.com>
Cc: stable@vger.kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/pmbus/ucd9000.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/hwmon/pmbus/ucd9000.c
+++ b/drivers/hwmon/pmbus/ucd9000.c
@@ -80,11 +80,11 @@ struct ucd9000_debugfs_entry {
  * It has been observed that the UCD90320 randomly fails register access when
  * doing another access right on the back of a register write. To mitigate this
  * make sure that there is a minimum delay between a write access and the
- * following access. The 250us is based on experimental data. At a delay of
- * 200us the issue seems to go away. Add a bit of extra margin to allow for
+ * following access. The 500 is based on experimental data. At a delay of
+ * 350us the issue seems to go away. Add a bit of extra margin to allow for
  * system to system differences.
  */
-#define UCD90320_WAIT_DELAY_US 250
+#define UCD90320_WAIT_DELAY_US 500
 
 static inline void ucd90320_wait(const struct ucd9000_data *data)
 {


