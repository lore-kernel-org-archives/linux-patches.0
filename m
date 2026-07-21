Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A72029CE9;
	Tue, 21 Jul 2026 21:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669038; cv=none; b=FMpLw5RheLnMLmmqOb086gMwsdwFi2PRIytymONKWdIFjOGPR2nEBZG3EvH5vvoa985t1sLkztZFag/S5hbg36f9zZFC96AV0izloiy+C4aUXFIhYeZKykdxiy3NwO51xc2wljeKC6Ov3uyQHPfnD1DrZ6CicCw5LINkLctF/Is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669038; c=relaxed/simple;
	bh=ARu3JDMWRLFYlqt8GYArcPEhyUg6A4w2jDFlwUTdng0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lVJuWNzYy/OydskQQYIbjKGrC0Fp/+Rl1H+rxYYjcZKAeBftz3d6WLqpuExE8i7FC3jFOs01q07tGiAdSIFTZo0UzWvbdqq8KyO1OQhQkGf5cWYgl/JI/usEBR43sZUwuvMzeaw9R5uvQyehnFPUpygE3wwNqU4t+pt5skUkDIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jKhifiAq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jKhifiAq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FB2E1F000E9;
	Tue, 21 Jul 2026 21:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669037;
	bh=J5cTQAFXrqVyVENZ1nF9bSTuynvCQA1eR+Hp8nsZcTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jKhifiAqtmEgbCYRVr3l1aTH1eB2tj+fdtdxD9dHrJWrRAnNzIkUU5s8RSPUFlEJh
	 SuctHHQoAQt3G2TGcks8zQIaeqDzyQ4NhIYFZxxU9YWoaYQbRao9pamHXB3ijt3c56
	 jxgoRvH5HGvfeXqFla+R0UpuI7iU8elx1crTRGAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Disseldorp <ddiss@suse.de>,
	Lee Duncan <lduncan@suse.com>,
	John Garry <john.g.garry@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0403/1067] scsi: target: Fix hexadecimal CHAP_I handling
Date: Tue, 21 Jul 2026 17:16:44 +0200
Message-ID: <20260721152433.649211730@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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



