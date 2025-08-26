Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAAEF341678;
	Tue, 26 Aug 2025 11:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208029; cv=none; b=EEhhElzen/0fT7E/zjPoP5/980y0oxyEId92ndOxR/7PlXMBYhxoJXSq0iFZsZCSRvwmCkaaFe2uVJmPDVhZUJs7qCOwTXXm/t0G7nxOVBQ1rfBMzzkd1RosEoplr7BFeEqcCHkNfV3JDJDBqIFbFBwtT/bMv8kgtpVJMZ3R4GA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208029; c=relaxed/simple;
	bh=Zs8ji/CKNJDtUxeWQ+nINJFucux5SfzVMAYxy/sq4HU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kwNR32ianVyG16zJSHSRAu8UpjCRWTOTvdZEcRnqOaXoF8Jno3Yv2Wvfe/6f5Yzgf8r6EE8WaM3JEZQxk6X2B2io6o4E822oJiThh/VAOctw8l/JRkaYTedF67MNU3T2IWr5xjhRBlu+x8q1QxI+e7w3tybMnyfb+mKA1q+9j18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dFynWSVw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dFynWSVw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72172C4CEF1;
	Tue, 26 Aug 2025 11:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208028;
	bh=Zs8ji/CKNJDtUxeWQ+nINJFucux5SfzVMAYxy/sq4HU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dFynWSVwr+KCVIH50JE/0yftn6RMxaoYJMRRfn1BIhLnKc/iMD6J+e/LrbWMfAazV
	 HRHG9EBCr05XMdRNtGkIdsgA4ON+YJrzrq0hNJn2YzJ270XMukv1lAkJKfK+5WpEUs
	 M8/kFxRplzQwlXbGRdjT2m6TtSCouiNlfAfkUX8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	Christian Schrefl <chrisi.schrefl@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 383/457] drm: nova-drm: fix 32-bit arm build
Date: Tue, 26 Aug 2025 13:11:07 +0200
Message-ID: <20250826110946.763089207@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

[ Upstream commit db2e7bcee11cd57f95fef3c6cbb562d0577eb84a ]

In 32-bit arm, the build fails with:

    error[E0308]: mismatched types
      --> drivers/gpu/drm/nova/file.rs:42:28
       |
    42 |         getparam.set_value(value);
       |                  --------- ^^^^^ expected `u64`, found `u32`
       |                  |
       |                  arguments to this method are incorrect
       |
    note: method defined here
      --> drivers/gpu/drm/nova/uapi.rs:29:12
       |
    29 |     pub fn set_value(&self, v: u64) {
       |            ^^^^^^^^^        ------
    help: you can convert a `u32` to a `u64`
       |
    42 |         getparam.set_value(value.into());
       |                                 +++++++

The reason is that `Getparam::set_value` takes a `u64` (from the UAPI),
but `pci::Device::resource_len()` returns a `resource_size_t`, which is a
`phys_addr_t`, which may be 32- or 64-bit.

Thus add an `into()` call to support the 32-bit case, while allowing the
Clippy lint that complains in the 64-bit case where the type is the same.

Fixes: cdeaeb9dd762 ("drm: nova-drm: add initial driver skeleton")
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Reviewed-by: Christian Schrefl <chrisi.schrefl@gmail.com>
Link: https://lore.kernel.org/r/20250724165441.2105632-1-ojeda@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nova/file.rs | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nova/file.rs b/drivers/gpu/drm/nova/file.rs
index 7e59a34b830d..4fe62cf98a23 100644
--- a/drivers/gpu/drm/nova/file.rs
+++ b/drivers/gpu/drm/nova/file.rs
@@ -39,7 +39,8 @@ impl File {
             _ => return Err(EINVAL),
         };
 
-        getparam.set_value(value);
+        #[allow(clippy::useless_conversion)]
+        getparam.set_value(value.into());
 
         Ok(0)
     }
-- 
2.50.1



