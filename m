Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA6E4F55A5;
	Wed,  9 Sep 2026 13:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961791; cv=none; b=VSKbzQRWFaS6lEcBzDuzqqjzJErG2JK+TTfgXSuo2sa2uuUrYBfQDjS9o80aMpOuIuVi4OlUdrfNA92pjE29lUjcyBx0BUu/RmdGr63+PYcECwN4IOqEkp3S0GFR/d+maIQaN7DGLwRgC1sn3n/IRSvk2QhgxYU7i0XKJE9khng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961791; c=relaxed/simple;
	bh=EOrCpsif1YfPphjNDvZ7rR3+9soQD3uM1Y2K/5uXSds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ohs+aqQWILCF8fVYtEsWrihgDGMi2aZgz3BWQLEC7VqUlUi8gHSnath0kMG17zMVkr9wHVGLOtTXf+Ko4yM3ESFKlUYaDcCtoSYS1x5LJ6SBzo7VbMcd3VGiTVVhj+K4Cb6ZdQSjtX31Ip0z77YMGv3jZniOQEflr84UcbnVqKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C6dNeZt2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C6dNeZt2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C0A31F00A3A;
	Wed,  9 Sep 2026 13:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961790;
	bh=duJRXaPqkc+7OyA3e+C7Arcq9oWBn57ek4CuP1SmHXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C6dNeZt2B5hz7XeD/+x10WKzUj4FIsAjhxxOAOJU201nEzi0MVAcUhLLyzvg06reH
	 I+cD1RpGZg8Y9+fK+GV/c3IeqbmQojfHxVNChr4OX22MGAelApRjcYs31j+D3cxGUD
	 ww196TfMN5w0AcQPzDGHCS5RmMcRPeoQf29qcKXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sujal Tuladhar <sujaltuladhar1231@gmail.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 7.2 067/556] scsi: target: iscsi: Reserve a terminator byte for the login payload
Date: Wed,  9 Sep 2026 15:35:47 +0200
Message-ID: <20260909134232.818930688@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sujal Tuladhar <sujaltuladhar1231@gmail.com>

commit f4825922d2fb371e2b969697d792077f1b62b62c upstream.

iscsi_target_check_login_request() rejects a login PDU whose
DataSegmentLength exceeds MAX_KEY_VALUE_PAIRS, but the test is '>' and
login->req_buf is allocated with exactly MAX_KEY_VALUE_PAIRS
bytes. Since iscsit_get_login_rx() receives payload_length + padding
bytes, where

	padding = ((-payload_length) & 3);

any payload_length from 8189 to 8192 fills the whole 8192 byte
buffer. The write stays in bounds, but no byte is left for a NUL
terminator.

The buffer is subsequently consumed as a C string. In the CHAP path
chap_check_algorithm() calls kstrdup(a_str), and extract_param() calls
strstr(in_buf, pattern) followed by strlen_semi(), none of which take a
length. convert_null_to_semi() additionally rewrites every embedded NUL
to ';', so even a payload made of well formed NUL separated key=value
records is left without a terminator. These walk past the end of the
object into adjacent slab memory. It is reachable by an unauthenticated
initiator against a portal configured for CHAP; when authentication is
not required iscsi_login_zero_tsih_s2() rewrites AuthMethod to None and
the CHAP path is never entered.

Allocate one extra byte. kzalloc() zeroes it and nothing ever writes to
it, as every writer copies to offset 0 for at most MAX_KEY_VALUE_PAIRS
bytes, so the buffer is always terminated.

Fixes: e48354ce078c ("iscsi-target: Add iSCSI fabric support for target v4.1")
Assisted-by: Claude Opus5 (custom harness)
Cc: stable@vger.kernel.org
Signed-off-by: Sujal Tuladhar <sujaltuladhar1231@gmail.com>
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/target/iscsi/iscsi_target_login.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -47,7 +47,7 @@ static struct iscsi_login *iscsi_login_i
 	login->conn = conn;
 	login->first_request = 1;
 
-	login->req_buf = kzalloc(MAX_KEY_VALUE_PAIRS, GFP_KERNEL);
+	login->req_buf = kzalloc(MAX_KEY_VALUE_PAIRS + 1, GFP_KERNEL);
 	if (!login->req_buf) {
 		pr_err("Unable to allocate memory for response buffer.\n");
 		goto out_login;


