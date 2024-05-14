Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1EF94594C;
	Tue, 14 May 2024 11:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687479; cv=none; b=jbSulSjpUQyJKzW8dD0Z12kcQf0aRC7v9T94fDjMOiZ74wXjUlJd0gmttTHjcisaMVdpRBapUU9awmqb6BLTpPD9/PuBTi0me+aykBJJT0KG45y3e4sZQQqQmupeuid/OlkOGPWJYPZ5vu588AJOjcGmYjh3pNwnBPAgHN0bQBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687479; c=relaxed/simple;
	bh=owlWFrzGyOVGbkb3H/hhg2v0wSAxV7IWygCPJ1lyFWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FJmbZG+/Le0lMoBOefutBrMpBshSr240ig35tZ4KYfhcB/PKNukozrnPHkJL9WCA4CMyLsvw2Io5Joxkmc8Zsz+bvlXvjBMWMmhIlukzAW6tvq1AtWLO3O7hGjW6GdhJSf2DiOwbkvf5KNNkqpVTbUs++Hs3JkecMGcj4yyWm+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SRwTydB6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SRwTydB6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B1DBC32781;
	Tue, 14 May 2024 11:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687479;
	bh=owlWFrzGyOVGbkb3H/hhg2v0wSAxV7IWygCPJ1lyFWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SRwTydB6bSPYLJsuH0F4WD2pndg5L4ryMyzPUaz+r7wm94spPOxj/YJ/pQHROM5Wt
	 ErMejyDIJJ7VAIM/hdjkEOfCmMKKW5yF+XWC1+pOnXSjy22gZTTkeQZd/kJSOQJiJr
	 TZoHWIPilnN+VrqJsGdUh6oiP/I4ZBubs/WSOaDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lakshmi Yadlapati <lakshmiy@us.ibm.com>,
	Eddie James <eajames@linux.ibm.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.10 110/111] hwmon: (pmbus/ucd9000) Increase delay from 250 to 500us
Date: Tue, 14 May 2024 12:20:48 +0200
Message-ID: <20240514101001.313809384@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100957.114746054@linuxfoundation.org>
References: <20240514100957.114746054@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


