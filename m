Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 074A01D0BBC;
	Wed,  2 Oct 2024 13:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876633; cv=none; b=uHvI16/CFXm9My2z1pz9nZT4FxUcTFErbmPDU34iy6WGanIcp/4OsGv9+SIYYeiteOJx9bXFczYl7Go9Bx1GeyNxUXlTQoNVWfJyj4XsOpTfIo2SS8xU0Q32DKri0ilA99G5Z/bP2aHWAROWma7/r660IkYaUddbj/zEaKrjxKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876633; c=relaxed/simple;
	bh=9EW9hzjdLrFx2G5MCXwg3jJnxGQZrXzFxztsS7L+1HE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sewUJiG7FtjnXnFBOQ9WRD8T45EbZ2Sj0/huMuFwaTp0QeJDzv2YRHYlCVIg7UzHRmA8Q+4+dc5JC1RfFjDk/3IdMKMnC5W8HUPAWkf27o+ojWl2WaNQJBIx9M87H4csKAwJe+izYclFtlMG/t+/sXuxaou6GVcSFl8ZcBYiMlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LNjJ15yU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LNjJ15yU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 834DBC4CEC5;
	Wed,  2 Oct 2024 13:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876632;
	bh=9EW9hzjdLrFx2G5MCXwg3jJnxGQZrXzFxztsS7L+1HE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LNjJ15yU1OsBuIv7ZegrG3Qdf1ErNBVh20HO3ZZ4NmNYbz/1sTLFzlYC9c79PhvQU
	 RMugShPP7wVOQ6qIJXIghS/xw0NiZN9a1zjMRUfVfsXgKnSvNHRFci1iCVde/YXLIC
	 OB0opx8u4KWGos5tcMjKXfdaFDXXKtPkKHQF5L3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.11 510/695] selftests/bpf: correctly move log upon successful match
Date: Wed,  2 Oct 2024 14:58:28 +0200
Message-ID: <20241002125842.838776031@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eduard Zingerman <eddyz87@gmail.com>

commit d0a29cdb6ef95d8a175e09ab2d1334271f047e60 upstream.

Suppose log="foo bar buz" and msg->substr="bar".
In such case current match processing logic would update 'log' as
follows: log += strlen(msg->substr); -> log += 3 -> log=" bar".
However, the intent behind the 'log' update is to make it point after
the successful match, e.g. to make log=" buz" in the example above.

Fixes: 4ef5d6af4935 ("selftests/bpf: no need to track next_match_pos in struct test_loader")
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20240820102357.3372779-3-eddyz87@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/test_loader.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/bpf/test_loader.c
+++ b/tools/testing/selftests/bpf/test_loader.c
@@ -545,7 +545,7 @@ static void validate_msgs(char *log_buf,
 		if (msg->substr) {
 			match = strstr(log, msg->substr);
 			if (match)
-				log += strlen(msg->substr);
+				log = match + strlen(msg->substr);
 		} else {
 			err = regexec(&msg->regex, log, 1, reg_match, 0);
 			if (err == 0) {


