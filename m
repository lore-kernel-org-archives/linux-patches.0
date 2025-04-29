Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A0EA2AE96;
	Tue, 29 Apr 2025 18:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949831; cv=none; b=TrdVS6UVkDB31YvN/GGxPU1/W0lIk2UR4w1hPMzyLKFZ1wwNI1CodEsCi98Go35mvOUBjxef7YWhSAV2Wrv2k0IG6raYFapnSsFryUFGFZv31gFShK9tq+3jeak0O7mjNAwo1xX+na3jX1WbC6DiWv1+kIk9htRuORq5G3SjO20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949831; c=relaxed/simple;
	bh=5utZ+PkDzOmd3mtjhPX5I2w6zhnYq8ChIZghx7jG0mU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dt2etExb0IjYKPvoontZGdle+Uj31jIIMFTjO/akpYFLjlNqK9CemMXy8Qw3iq4OP7e6iNJ403u1z2w/2KUX1ygZ8A5o1hoWVqqDTOvkRrAbXpZwu69o37Eh9y9vnbhfCW6YIs0a2yFB372LoTIfI43DDncTlejy7PDw4T2wB74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GymE9wQ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GymE9wQ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DEECC4CEE3;
	Tue, 29 Apr 2025 18:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949830;
	bh=5utZ+PkDzOmd3mtjhPX5I2w6zhnYq8ChIZghx7jG0mU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GymE9wQ0UTtSP2/TAYwaXsPkM5eYIurX+rfiI67rjBd2MqnK39P7QV8yRjsyhRHxz
	 ouju5whxLLyGUOrenUHR19E49XiIbAF0/n6HRMXySniL5jkh10i+ZtLNScnblsci74
	 axTNiXel8Z39edNqZPlRUrYtSu0fcwwnSvumJxDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Johannes Thumshirn <jth@kernel.org>
Subject: [PATCH 6.1 071/167] mcb: fix a double free bug in chameleon_parse_gdd()
Date: Tue, 29 Apr 2025 18:42:59 +0200
Message-ID: <20250429161054.640245402@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

commit 7c7f1bfdb2249f854a736d9b79778c7e5a29a150 upstream.

In chameleon_parse_gdd(), if mcb_device_register() fails, 'mdev'
would be released in mcb_device_register() via put_device().
Thus, goto 'err' label and free 'mdev' again causes a double free.
Just return if mcb_device_register() fails.

Fixes: 3764e82e5150 ("drivers: Introduce MEN Chameleon Bus")
Cc: stable <stable@kernel.org>
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Signed-off-by: Johannes Thumshirn <jth@kernel.org>
Link: https://lore.kernel.org/r/6201d09e2975ae5789879f79a6de4c38de9edd4a.1741596225.git.jth@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mcb/mcb-parse.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mcb/mcb-parse.c
+++ b/drivers/mcb/mcb-parse.c
@@ -101,7 +101,7 @@ static int chameleon_parse_gdd(struct mc
 
 	ret = mcb_device_register(bus, mdev);
 	if (ret < 0)
-		goto err;
+		return ret;
 
 	return 0;
 


