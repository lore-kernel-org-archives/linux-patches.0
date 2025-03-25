Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7355E1DD9D3;
	Tue, 25 Mar 2025 12:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905973; cv=none; b=A8GszPzCbKjE6bfQhOE3Gizy8ZLQyk2CjVAi7r3YjWmLBRuXwwRMMCKdbKA7uWpAiNVTXRvLCc+YnPLObOP039Ey3QzmteamqFMnO9/bHjjD+6MJrf0b95PRScKzDboleGTfKYby5HDp2hYu1hXCwyWoODYNr77/0TKa9Xi0D8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905973; c=relaxed/simple;
	bh=9RWDGuRF/zMDQL3h+wTiFhNMcwf1K1Tq/iDxPpyr6eY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n9d2WWC5z8WrUZEHHhIOAQLmEJk9qzWEu8tmvs1PdBxMln04fOJGeFfO+d209YS3k30ZAG+H2JNgEz0eiOE5q6eHl5ava4eosDMgKSd1jjV1bp8XjiWOV+61NWRhhOkUEMxjs+iQTGpOcRj1T2pYMYzkOTtSgHpb6uSvYUCWmt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nW5pXszp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nW5pXszp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 258A3C2BCB6;
	Tue, 25 Mar 2025 12:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905973;
	bh=9RWDGuRF/zMDQL3h+wTiFhNMcwf1K1Tq/iDxPpyr6eY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nW5pXszpE8M126c7O7EgxyzLe8Hvl7XD3QpDRBdc/DWcfF7+3CeK0o7bbkfyfnDSx
	 5Ys/UqQcbCjCbXwepJN/f7yUNcPieIgif9QXfcA1QaScQkIs6xJ7U3708uMx2EJsNN
	 gVT3bdBL2nVrqrlnUzg3i7tssj0BMCYVCVI85O1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Eggers <ceggers@arri.de>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.13 066/119] regulator: dummy: force synchronous probing
Date: Tue, 25 Mar 2025 08:22:04 -0400
Message-ID: <20250325122150.744535334@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Eggers <ceggers@arri.de>

commit 8619909b38eeebd3e60910158d7d68441fc954e9 upstream.

Sometimes I get a NULL pointer dereference at boot time in kobject_get()
with the following call stack:

anatop_regulator_probe()
 devm_regulator_register()
  regulator_register()
   regulator_resolve_supply()
    kobject_get()

By placing some extra BUG_ON() statements I could verify that this is
raised because probing of the 'dummy' regulator driver is not completed
('dummy_regulator_rdev' is still NULL).

In the JTAG debugger I can see that dummy_regulator_probe() and
anatop_regulator_probe() can be run by different kernel threads
(kworker/u4:*).  I haven't further investigated whether this can be
changed or if there are other possibilities to force synchronization
between these two probe routines.  On the other hand I don't expect much
boot time penalty by probing the 'dummy' regulator synchronously.

Cc: stable@vger.kernel.org
Fixes: 259b93b21a9f ("regulator: Set PROBE_PREFER_ASYNCHRONOUS for drivers that existed in 4.14")
Signed-off-by: Christian Eggers <ceggers@arri.de>
Link: https://patch.msgid.link/20250311091803.31026-1-ceggers@arri.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/regulator/dummy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/regulator/dummy.c
+++ b/drivers/regulator/dummy.c
@@ -60,7 +60,7 @@ static struct platform_driver dummy_regu
 	.probe		= dummy_regulator_probe,
 	.driver		= {
 		.name		= "reg-dummy",
-		.probe_type	= PROBE_PREFER_ASYNCHRONOUS,
+		.probe_type	= PROBE_FORCE_SYNCHRONOUS,
 	},
 };
 


