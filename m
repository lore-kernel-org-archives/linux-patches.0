Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12F433C53A;
	Fri,  9 Jan 2026 12:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962505; cv=none; b=h3reSVA8P+Pt3sYc+k2Inv6F4p9yWCGT6hMXgLGuYXZCsquClIFc8+euVjoyQI6k/Z8cqnBHwiDsFnDpEhmT1LBx9tkDKSQE7HH+LNmMQE8wUxYnAMG11EFOp3mxRs2nwiYXBa+DlpRoq3pEnlAGbNrgu1GzPBo98cdVuyYHbS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962505; c=relaxed/simple;
	bh=3KI1USyMLHSnMDEU+K+nFCBZeDDJXchWyMG7prvhtV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QqrFjLi1uOWyUZjkng+YTyo7G3B4QQ5TZtRCuTSUHRUXvXF6XGMtvg/hkFUXET/sqd21/VscV5+jpuh/ydwcoA7MAzVdF5t5dJL+JjqkV0CCicITDldzz5NSGhwHNty/sXPlReqb+3GqhU97ir07TVLpfkH0DuvlkcI3IAIGxBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C+Qj7w43; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C+Qj7w43"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DF6FC4CEF1;
	Fri,  9 Jan 2026 12:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962504;
	bh=3KI1USyMLHSnMDEU+K+nFCBZeDDJXchWyMG7prvhtV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C+Qj7w43ABWCgW//TovZ2kWjCpDPf17uZNBn0+VrrauJpiywe6+WIPrtLeLusEq1g
	 jWYlboUpZ3pG/9K+k1bCNX0wWwSI4O85DemErl25yoGzrYebbYzrfcnXMuLhDq91MX
	 +25/Ft/K7fkUbjzAK/PRUu7Ine5p5XJAoRjt5r84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>
Subject: [PATCH 6.1 355/634] platform/chrome: cros_ec_ishtp: Fix UAF after unbinding driver
Date: Fri,  9 Jan 2026 12:40:33 +0100
Message-ID: <20260109112130.882413964@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tzung-Bi Shih <tzungbi@kernel.org>

commit 944edca81e7aea15f83cf9a13a6ab67f711e8abd upstream.

After unbinding the driver, another kthread `cros_ec_console_log_work`
is still accessing the device, resulting an UAF and crash.

The driver doesn't unregister the EC device in .remove() which should
shutdown sub-devices synchronously.  Fix it.

Fixes: 26a14267aff2 ("platform/chrome: Add ChromeOS EC ISHTP driver")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20251031033900.3577394-1-tzungbi@kernel.org
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/chrome/cros_ec_ishtp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/platform/chrome/cros_ec_ishtp.c
+++ b/drivers/platform/chrome/cros_ec_ishtp.c
@@ -715,6 +715,7 @@ static void cros_ec_ishtp_remove(struct
 
 	cancel_work_sync(&client_data->work_ishtp_reset);
 	cancel_work_sync(&client_data->work_ec_evt);
+	cros_ec_unregister(client_data->ec_dev);
 	cros_ish_deinit(cros_ish_cl);
 	ishtp_put_device(cl_device);
 }


