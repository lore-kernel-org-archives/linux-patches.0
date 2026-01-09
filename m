Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AFD92EC54D;
	Fri,  9 Jan 2026 12:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961708; cv=none; b=G3PnaE7fFXU6DWgZUAsi8BO2XL+rz2BttMmeUs1yxv7m/6q8gyUePUeC5LjKF/MkVa+b2FRo2L2ll0W93XgK4gmmxR1SsmI0jkUgeKTVMzMQw8d4HDhNFMbN1l7jX266azTM8epS/RdI3xKiLKxWcdfSCJEJrN8HlwBMSowAhuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961708; c=relaxed/simple;
	bh=Gj5lYa/mpeX2UWvwo1WkS05B+FbYkxZUla7TkmpcDcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WdAr1VsWN2zaVWO+291lmSuysZPNt0U3Uf4eYlaLGPj4JvtC0fYFAWoeV1GCYIhTjZqMsvNmPOSF+1YFEVtCEbhf8WCIMPjLcWMwrcBn7/LGKjl8f3ji3aLI+cghaDMeL65h72hesi7AKuyNYqe40kBfesBHAcZXZk4g0iTV1I8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DwiRDQJe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DwiRDQJe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08AB7C4CEF1;
	Fri,  9 Jan 2026 12:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961708;
	bh=Gj5lYa/mpeX2UWvwo1WkS05B+FbYkxZUla7TkmpcDcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DwiRDQJekdwqLcARCszy24cPHNK9kyf17Myk3N5GP80OIuC9Z8VZ7pbFAWHThYWny
	 LtiQU24mNk1MvC0g5Kk9DnVtxwPLeB+9G0QxedR3/iduWXm7EB1q7lRS+2xzlqtHbD
	 xYzEEsbyKHY4hkxB5YxU4Gm59rG8wu1V8Px/kOiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Petr Mladek <pmladek@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 109/634] lib/vsprintf: Check pointer before dereferencing in time_and_date()
Date: Fri,  9 Jan 2026 12:36:27 +0100
Message-ID: <20260109112121.535843162@linuxfoundation.org>
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 372a12bd5df0199aa234eaf8ef31ed7ecd61d40f ]

The pointer may be invalid when gets to the printf(). In particular
the time_and_date() dereferencing it in some cases without checking.

Move the check from rtc_str() to time_and_date() to cover all cases.

Fixes: 7daac5b2fdf8 ("lib/vsprintf: Print time64_t in human readable format")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Link: https://patch.msgid.link/20251110132118.4113976-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/vsprintf.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 2b0b5f08b8fc0..f039d5cae3756 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1862,9 +1862,6 @@ char *rtc_str(char *buf, char *end, const struct rtc_time *tm,
 	bool found = true;
 	int count = 2;
 
-	if (check_pointer(&buf, end, tm, spec))
-		return buf;
-
 	switch (fmt[count]) {
 	case 'd':
 		have_t = false;
@@ -1930,6 +1927,9 @@ static noinline_for_stack
 char *time_and_date(char *buf, char *end, void *ptr, struct printf_spec spec,
 		    const char *fmt)
 {
+	if (check_pointer(&buf, end, ptr, spec))
+		return buf;
+
 	switch (fmt[1]) {
 	case 'R':
 		return rtc_str(buf, end, (const struct rtc_time *)ptr, spec, fmt);
-- 
2.51.0



