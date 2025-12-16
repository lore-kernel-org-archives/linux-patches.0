Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F4636D4E7;
	Tue, 16 Dec 2025 12:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888016; cv=none; b=d9d7fpTdr/Sw128RiK4dom3pVd8+6GxlNHZepp1PuVNc4NcRveNl40AUkl7We0FlL+UMgiGdawuPz8Dudo2IzN5LiKlf7hm4G7Dk0wbl/6sFwXj7J+IXENDhlMrmtnydCC36XY95kqnvT5aQU4CcsxDX8QFCBgS87t6j0d0HRFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888016; c=relaxed/simple;
	bh=x3S/59zaeYEDO6HEzziMsxu6bWYDN7A2FEF5/Cjmgck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KQ3QQp98ehaJWEVuWFfB7YzwSVylug9r2a+b+TyvS5yZVHhBFji6ggWELWJceYCLcMLH8Mb/9L7UJsUf8zCA0rwCd2Q9zZRq477OB8NG8DDIn1d42yB7erFszxPSnMIqJMybYOd/1aOEE6/Fu4WoqUH9yYDS3w8TmnZf17YMPho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0EsKx0x5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0EsKx0x5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1DCAC4CEF1;
	Tue, 16 Dec 2025 12:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888016;
	bh=x3S/59zaeYEDO6HEzziMsxu6bWYDN7A2FEF5/Cjmgck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0EsKx0x5PqdFPDyrePAfWawf7tWUKj0MUWc3Iw8qooz460dYC/wWq+dOpmTeFFqW9
	 P6Squ2iEd/7qf4POTjGp/hey3Ftp/YxAP9QFwRI4WTSbfqSFBr6Ti2PbKFJiZE3xya
	 J5zNLBMPBMSirbroCX6ytRMcFcEz3vxMmehXGs1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Maguire <alan.maguire@oracle.com>,
	Song Liu <song@kernel.org>,
	Quentin Monnet <qmo@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 406/614] bpftool: Allow bpftool to build with openssl < 3
Date: Tue, 16 Dec 2025 12:12:53 +0100
Message-ID: <20251216111416.084488181@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Alan Maguire <alan.maguire@oracle.com>

[ Upstream commit 90ae54b4c7eca42d5ce006dd0a8cb0b5bfbf80d0 ]

ERR_get_error_all()[1] is a openssl v3 API, so to make code
compatible with openssl v1 utilize ERR_get_err_line_data
instead.  Since openssl is already a build requirement for
the kernel (minimum requirement openssl 1.0.0), this will
allow bpftool to compile where opensslv3 is not available.
Signing-related BPF selftests pass with openssl v1.

[1] https://docs.openssl.org/3.4/man3/ERR_get_error/

Fixes: 40863f4d6ef2 ("bpftool: Add support for signing BPF programs")
Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
Acked-by: Song Liu <song@kernel.org>
Acked-by: Quentin Monnet <qmo@kernel.org>
Link: https://lore.kernel.org/r/20251120084754.640405-2-alan.maguire@oracle.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/sign.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/bpf/bpftool/sign.c b/tools/bpf/bpftool/sign.c
index b34f74d210e9c..f9b742f4bb104 100644
--- a/tools/bpf/bpftool/sign.c
+++ b/tools/bpf/bpftool/sign.c
@@ -28,6 +28,12 @@
 
 #define OPEN_SSL_ERR_BUF_LEN 256
 
+/* Use deprecated in 3.0 ERR_get_error_line_data for openssl < 3 */
+#if !defined(OPENSSL_VERSION_MAJOR) || (OPENSSL_VERSION_MAJOR < 3)
+#define ERR_get_error_all(file, line, func, data, flags) \
+	ERR_get_error_line_data(file, line, data, flags)
+#endif
+
 static void display_openssl_errors(int l)
 {
 	char buf[OPEN_SSL_ERR_BUF_LEN];
-- 
2.51.0



