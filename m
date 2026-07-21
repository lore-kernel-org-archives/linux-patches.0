Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55DD2471257;
	Tue, 21 Jul 2026 19:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662128; cv=none; b=TA+/GqJrOTcq2M9MxNslu2fRU6EVZNBGdA2DE7x3I3q/HePceX/82TNhxM1Q7WOhfESy0r0X9NC7xb2dZrIGXGr5jj6jBTM7b6I/SzXw7icJtZboe818WCY5pwzQo7yVbYHtMthpb+7B9mam/0Q6+sM2XgoKF+I5mrduoYy6+E0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662128; c=relaxed/simple;
	bh=2juIxyUT0Qm5ZjugHEOYxx4ejKlrIOB4XnSN4QGl7Rs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TkvMuzuREPC5V+74nkqahRGIlVVf6bVAEBzqytw0lfCKotdWHVmj/I0hIH1RgAGuLeRkXA0+xS0hbJUo7DP24zo0N8eT13zGpXzOBJJoHriirAqwEakd9dBh2cseZhq9u8v79Ev6FgnaGa+BpX29Cf9NqpUEZIQYeiR8LXy7EEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lc1g1NiP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lc1g1NiP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 644E71F00A3A;
	Tue, 21 Jul 2026 19:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662126;
	bh=TeZ8+12nAV4nJYfBfgPD85/LCql65SpIQHMlVc1UFoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lc1g1NiPhHuzOoow8oAcJsSlLs2z2XCLZ8zW0ttLS4mLrat71nZwtXEv2nsciSSnA
	 2Zl35Ky3zCka0PbnO7WUcMluHqPiMi6/OwfBvrEm3F/G81y7wXzHgLuNQJ0y63jx7Z
	 sZgdE6l4e0otXEBET5/7aH2ETJFP5oXOICLYJahk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Disseldorp <ddiss@suse.de>,
	Lee Duncan <lduncan@suse.com>,
	John Garry <john.g.garry@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0273/1276] scsi: target: Fix hexadecimal CHAP_I handling
Date: Tue, 21 Jul 2026 17:11:56 +0200
Message-ID: <20260721152452.189201611@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Disseldorp <ddiss@suse.de>

[ Upstream commit 7e161211f1dd5288b4ea802b30e70ef919ebc3da ]

A mutual CHAP handshake requires target processing of an initiator-sent
CHAP_I identifier. The RFC 3720 specification states:

  11.1.4.  Challenge Handshake Authentication Protocol (CHAP)
  ...
  CHAP_A=<A> CHAP_I=<I> CHAP_C=<C>
  ...
  Where N, (A,A1,A2), I, C, and R are (correspondingly) the Name,
  Algorithm, Identifier, Challenge, and Response as defined in
  [RFC1994], N is a text string, A,A1,A2, and I are numbers

CHAP_I parsing currently calls extract_param(), which returns the
@identifier string (stripped of any 0b/0B or 0x/0X prefix) and a @type
which indicates DECIMAL, HEX, or BASE64 encoding (based on any stripped
prefix).

Any HEX encoded CHAP_I string is further processed via:

  ret = kstrtoul(&identifier[2], 0, &id);

This is incorrect for two reasons:

 * The @identifier string has already been stripped of the 0x/0X prefix,
   so skipping the first two bytes omits part of the number.

 * The kstrtoul() call specifies a base of 0, which will see
   &identifier[2] parsed as a decimal, unless a '0x' or (octal) '0' is
   erroneously present at that offset.

Fix this by passing the (zero-offset) identifier string to kstrtoul()
along with a base=16 parameter. Also add an explicit error handler for
BASE64 encoding.

Hex-encoded CHAP_I handling can be testing using the libiscsi EncodedI
test linked below.

Reported-by: Sashiko (gemini/gemini-3.1-pro-preview)
Link: https://sashiko.dev/#/patchset/20260521151121.808477-1-hossu.alexandru%40gmail.com
Link: https://github.com/sahlberg/libiscsi/pull/473
Fixes: 85db7391310b ("scsi: target: iscsi: Validate CHAP_R length before base64 decode")
Signed-off-by: David Disseldorp <ddiss@suse.de>
Reviewed-by: Lee Duncan <lduncan@suse.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Link: https://patch.msgid.link/20260605122019.24146-2-ddiss@suse.de
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/iscsi/iscsi_target_auth.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_auth.c b/drivers/target/iscsi/iscsi_target_auth.c
index 02a4c9aff98d51..41e4def46ede69 100644
--- a/drivers/target/iscsi/iscsi_target_auth.c
+++ b/drivers/target/iscsi/iscsi_target_auth.c
@@ -437,9 +437,11 @@ static int chap_server_compute_hash(
 	}
 
 	if (type == HEX)
-		ret = kstrtoul(&identifier[2], 0, &id);
+		ret = kstrtoul(identifier, 16, &id);
+	else if (type == DECIMAL)
+		ret = kstrtoul(identifier, 10, &id);
 	else
-		ret = kstrtoul(identifier, 0, &id);
+		ret = -EINVAL;
 
 	if (ret < 0) {
 		pr_err("kstrtoul() failed for CHAP identifier: %d\n", ret);
-- 
2.53.0



